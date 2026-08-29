{
  lib,
  stdenv,
  fetchFromGitHub,
  buildBazelPackage,
  callPackage,
  python3,
  python311,
  python312,
  python313,
  python314,
  bash,
  coreutils,
  makeWrapper,
  patchelf,
  git,
  cacert,
  jdk21,
  runCommand,
  file,
  glibc,
  libgcc,
  zlib,
  xz,
  zstd,
  ncurses,
  libxml2,
  libffi,
  libedit,
  openssl,
  libbsd,
  libmd,
  bazel_9,
  bazelUnwrapped ? bazel_9,
}:

let
  clangLinux = callPackage ./clang-linux.nix { };
  llvmIfs = callPackage ./llvm-ifs-nix.nix { inherit clangLinux; };
  sysrootX86 = callPackage ./sysroot-nix.nix { moduleName = "sysroot-jammy-x86_64"; };
  sysrootAarch = callPackage ./sysroot-nix.nix { moduleName = "sysroot-jammy-aarch64"; };
  pythonStandalone311 = callPackage ./python-standalone-nix.nix { python = python311; };
  pythonStandalone312 = callPackage ./python-standalone-nix.nix { python = python312; };
  pythonStandalone313 = callPackage ./python-standalone-nix.nix { python = python313; };
  pythonStandalone314 = callPackage ./python-standalone-nix.nix { python = python314; };

  nixRpath = lib.makeLibraryPath [
    glibc
    stdenv.cc.cc.lib
    libgcc
    zlib
    xz
    zstd
    ncurses
    libxml2
    libffi
    libedit
    openssl
    libbsd
    libmd
  ];

  # nixpkgs bazel_9 (from source). buildBazelPackage calls
  # bazel.override { enableNixHacks = true }; bazel_9 has no such argument.
  # Generated py_binary stubs get a Nix env shebang via a rules_python patch.
  bazel = lib.makeOverridable (_args: bazelUnwrapped) { };

  wrapperBazelrc = ''
    # Generated for the Nix build; do not enable Modular's remote/disk caches.
    startup --server_javabase=${jdk21.home}
  '';

  localBazelrc = ''
    build --compilation_mode=opt
    build --spawn_strategy=standalone
    build --strategy=CppCompile=standalone
    build --strategy=CppLink=standalone
    build --strategy=TestRunner=standalone
    # Path mapping requires a sandboxed spawn; Nix cannot nest that sandbox.
    build --experimental_output_paths=off
    build --remote_cache=
    build --remote_executor=
    build --bes_backend=
    build --build_runfile_links
    build --config=disable-mypy
    build --//:host_modular_config=ci_build
    # bazel_9 patches --incompatible_strict_action_env's default PATH to Nix tools.
    common --override_repository=clang-linux-x86_64=${clangLinux}
    common --override_repository=clang-linux-aarch64=${clangLinux}
    common --override_repository=clang-macos=${clangLinux}
    common --override_repository=llvm-ifs=${llvmIfs}
    # nixpkgs clang omits PT_INTERP; cc-wrapper normally adds this.
    build --linkopt=-Wl,--dynamic-linker,${glibc}/lib/ld-linux-x86-64.so.2
    build --linkopt=-Wl,-rpath,${nixRpath}
  '';
  mojoCompiled = buildBazelPackage rec {
    # Keep this pname: it is the cached 3h compile. Slimming is a follow-on drv.
    pname = "mojo-unwrapped";
    version = "unstable-2026-08-21";

    src = fetchFromGitHub {
      owner = "modular";
      repo = "modular";
      rev = "577b6b839efa11d750cdf264f1094954cc7d5b25";
      hash = "sha256-A4fDR7UrCn1O+YqZv8M+ISw7eEO6R+UtSC3Bu7ponMU=";
    };

    inherit bazel;

    # Nix LLVM 22 + glibc sysroot replace Modular's S3 clang/jammy tarballs.
    # Do not inject Nix's cc-wrapper flags or drop rules_cc (bzlmod dep).
    dontAddBazelOpts = true;
    removeRulesCC = false;

    bazelFlags = [
      "--config=build-mojo"
      "--compilation_mode=opt"
      "--//:host_modular_config=ci_build"
    ];

    bazelBuildFlags = [
      "--verbose_failures"
      "--keep_going=false"
    ];

    bazelTargets = [ "//KGEN:mojo" ];

    nativeBuildInputs = [
      python3
      python311
      python312
      python313
      bash
      coreutils
      git
      makeWrapper
      patchelf
      cacert
      jdk21
      clangLinux
      llvmIfs
      sysrootX86
      sysrootAarch
      pythonStandalone311
      pythonStandalone312
      pythonStandalone313
      pythonStandalone314
    ];

    # Output is Nix-linked (glibc dynamic linker + rpath). Debug symbols are
    # stripped in the follow-on unwrapped derivation, not here.
    dontPatchELF = true;
    dontStrip = true;

    postPatch = ''
      mkdir -p build
      printf '%s\n' ${lib.escapeShellArg wrapperBazelrc} > build/wrapper.bazelrc
      printf '%s\n' ${lib.escapeShellArg localBazelrc} > local.bazelrc

      # Keep bzlmod downloads next to external/ (not inside it: that name
      # becomes @@repository_cache and cycles the module graph).
      echo "common --repository_cache=$bazelOut/repository_cache" >> local.bazelrc
      mkdir -p "$bazelOut/repository_cache"

      # Drop bazelisk so the Nix-provided bazel_9 is used.
      rm -f tools/bazel .bazelversion

      python3 - <<'PY'
      from pathlib import Path
      import re

      p = Path("bazel/common.MODULE.bazel")
      text = p.read_text()
      needle = 'http_archive = use_repo_rule("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")\n'
      insert = needle + 'local_repository = use_repo_rule("@bazel_tools//tools/build_defs/repo:local.bzl", "local_repository")\n'
      if needle not in text:
          raise SystemExit("http_archive rule missing from common.MODULE.bazel")
      if "local_repository = use_repo_rule" not in text:
          text = text.replace(needle, insert, 1)

      def replace_archive(text, name, path):
          pat = re.compile(
              rf'http_archive\(\n    name = "{re.escape(name)}",\n.*?\n    url = "[^"]+",\n\)',
              re.S,
          )
          repl = (
              f"local_repository(\n    name = \"{name}\",\n    path = \"{path}\",\n)"
          )
          new, n = pat.subn(repl, text, count=1)
          if n != 1:
              raise SystemExit(f"failed to replace {name} (matched {n})")
          return new

      text = replace_archive(text, "clang-linux-x86_64", "${clangLinux}")
      text = replace_archive(text, "clang-linux-aarch64", "${clangLinux}")
      text = replace_archive(text, "clang-macos", "${clangLinux}")
      text = replace_archive(text, "llvm-ifs", "${llvmIfs}")

      def strip_archive_override(text, name):
          pat = re.compile(
              rf'archive_override\(\n    module_name = "{re.escape(name)}",\n.*?\n\)\n',
              re.S,
          )
          new, n = pat.subn("", text, count=1)
          if n != 1:
              raise SystemExit(f"failed to strip archive_override {name} (matched {n})")
          return new

      text = strip_archive_override(text, "sysroot-jammy-x86_64")
      text = strip_archive_override(text, "sysroot-jammy-aarch64")

      # Keep Modular's python.toolchain() registrations so transitive
      # use_repo(python_3_11 / python_3_12) still resolve. Replace only the
      # linux-gnu payload with nixpkgs CPython (rules_python MINOR_MAPPING keys).
      python_use = 'use_repo(python, "python_" + PYTHON_VERSIONS[0])\n'
      if python_use not in text:
          raise SystemExit("python use_repo needle missing from common.MODULE.bazel")

      import hashlib

      def sha256_file(path):
          digest = hashlib.sha256()
          with open(path, "rb") as handle:
              for chunk in iter(lambda: handle.read(1 << 20), b""):
                  digest.update(chunk)
          return digest.hexdigest()

      def platform_override(version, tar):
          return (
              "python.single_version_platform_override(\n"
              '    platform = "x86_64-unknown-linux-gnu",\n'
              f'    python_version = "{version}",\n'
              f'    sha256 = "{sha256_file(tar)}",\n'
              '    strip_prefix = "python",\n'
              f'    urls = ["file://{tar}"],\n'
              ")\n"
          )

      overrides = (
          platform_override("3.11.14", "${pythonStandalone311}/python.tar.gz")
          + platform_override("3.12.12", "${pythonStandalone312}/python.tar.gz")
          + platform_override("3.13.11", "${pythonStandalone313}/python.tar.gz")
          + platform_override("3.14.2", "${pythonStandalone314}/python.tar.gz")
      )
      text = text.replace(python_use, overrides + python_use, 1)

      # Keep the lock file's platform keys (darwin/aarch64 configs). They
      # are select() labels only; shrinking them breaks analysis.

      p.write_text(text)

      mod = Path("MODULE.bazel")
      extra = (
          "\n"
          "local_runtime_repo = use_repo_rule(\n"
          '    "@rules_python//python/local_toolchains:repos.bzl",\n'
          '    "local_runtime_repo",\n'
          ")\n"
          "local_runtime_toolchains_repo = use_repo_rule(\n"
          '    "@rules_python//python/local_toolchains:repos.bzl",\n'
          '    "local_runtime_toolchains_repo",\n'
          ")\n"
          "local_runtime_repo(\n"
          '    name = "nix_python313",\n'
          '    interpreter_path = "${python313}/bin/python3",\n'
          '    on_failure = "fail",\n'
          ")\n"
          "local_runtime_toolchains_repo(\n"
          '    name = "nix_python_toolchains",\n'
          '    runtimes = ["nix_python313"],\n'
          '    default_runtimes = ["nix_python313"],\n'
          ")\n"
          'register_toolchains("@nix_python_toolchains//:all")\n'
          "local_path_override(\n"
          '    module_name = "sysroot-jammy-x86_64",\n'
          '    path = "${sysrootX86}",\n'
          ")\n"
          "local_path_override(\n"
          '    module_name = "sysroot-jammy-aarch64",\n'
          '    path = "${sysrootAarch}",\n'
          ")\n"
      )
      mod.write_text(mod.read_text() + extra)

      # disable-mypy only drops the output group; the aspect still analyzes
      # the full pycross lock (3.10/darwin select keys we no longer register).
      rc = Path("bazel/internal/common.bazelrc")
      rc_text = rc.read_text()
      aspect = "build --aspects=//bazel/pip:mypy.bzl%mypy_aspect\n"
      if aspect not in rc_text:
          raise SystemExit("mypy aspects line missing from common.bazelrc")
      rc_text = rc_text.replace(aspect, "# nix: mypy aspect disabled\n", 1)
      groups = "build --output_groups=+mypy\n"
      if groups not in rc_text:
          raise SystemExit("mypy output_groups line missing from common.bazelrc")
      rc.write_text(rc_text.replace(groups, "build --output_groups=-mypy\n", 1))

      # Generated py_binary stubs default to #!/usr/bin/env. The Nix sandbox
      # has no /usr. Patch rules_python via Modular's existing override.
      # Absolute interpreter: `env python3` fails under Bazel's `exec env -`
      # (empty PATH). FHS hid this because GNU env then searches /usr/bin.
      py_path = "${python313}/bin/python3"
      Path("bazel/public-patches/rules_python_stub_shebang.patch").write_text("\n".join([
          "--- a/python/private/py_runtime_info.bzl",
          "+++ b/python/private/py_runtime_info.bzl",
          "@@ -17,3 +17,3 @@",
          " ",
          '-DEFAULT_STUB_SHEBANG = "#!/usr/bin/env python3"',
          f'+DEFAULT_STUB_SHEBANG = "#!{py_path}"',
          " ",
      ]))
      common = Path("bazel/common.MODULE.bazel")
      common_text = common.read_text()
      revert = '"//bazel/public-patches:rules_python_revert.patch",\n'
      stub = '"//bazel/public-patches:rules_python_stub_shebang.patch",\n'
      if revert not in common_text:
          raise SystemExit("rules_python_revert.patch needle missing")
      if stub not in common_text:
          common.write_text(common_text.replace(revert, revert + "        " + stub, 1))

      # Workspace scripts keep POSIX shebangs; execvp reports ENOENT without FHS.
      shebang_map = (
          (b"#!/usr/bin/env python3", b"#!${python313}/bin/python3"),
          (b"#!/usr/bin/env python", b"#!${python313}/bin/python3"),
          (b"#!/usr/bin/env bash", b"#!${bash}/bin/bash"),
          (b"#!/bin/bash", b"#!${bash}/bin/bash"),
          (b"#!/bin/sh", b"#!${bash}/bin/sh"),
      )
      for path in Path(".").rglob("*"):
          if not path.is_file() or path.is_symlink():
              continue
          if path.suffix not in {".sh", ".py", ".bash"}:
              continue
          try:
              data = path.read_bytes()
          except OSError:
              continue
          if b"\0" in data[:128]:
              continue
          new = data
          for old, repl in shebang_map:
              if new.startswith(old):
                  new = repl + new[len(old) :]
                  break
          if new != data:
              path.chmod(path.stat().st_mode | 0o200)
              path.write_bytes(new)
      PY
    '';

    fetchAttrs = {
      sha256 = "sha256-AcGaD42vWFdMn4b7+NtYzyzaPHRdLnO+pJerwOm9xeo=";
      # Top-level doInstallCheck would otherwise run against the deps tarball.
      doInstallCheck = false;
      # buildBazelPackage forces allowedRequisites on the FOD; discard leftover
      # javabase / toolchain strings so the tarball is still a valid FOD.
      __structuredAttrs = true;
      unsafeDiscardReferences.out = true;
      nativeBuildInputs = [
        python3
        python311
        python312
        python313
        git
        patchelf
        cacert
        jdk21
        clangLinux
        llvmIfs
        sysrootX86
        sysrootAarch
        pythonStandalone311
        pythonStandalone312
        pythonStandalone313
        pythonStandalone314
      ];
      preBuild = ''
        export GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt"
        export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
        export JAVA_HOME="${jdk21.home}"
        ulimit -s unlimited || true
        mkdir -p "$bazelOut/repository_cache"
      '';
      postBuild = ''
        # Snapshot BCR metadata + external repos so the build phase can stay offline.
        BAZEL_USE_CPP_ONLY_TOOLCHAIN=1 USER=homeless-shelter \
          bazel --batch --output_base="$bazelOut" --output_user_root="$bazelUserRoot" \
            vendor --curses=no --config=build-mojo --config=disable-mypy \
            --compilation_mode=opt \
            --vendor_dir="$bazelOut/vendor" \
            --//:host_modular_config=ci_build \
            //KGEN:mojo

        # Nix clang/sysroot must not land in the FOD: ELF and ld scripts
        # contain /nix/store hashes which installPhase would rewrite.
        shopt -s nullglob
        rm -rf \
          "$bazelOut"/vendor/*clang-linux* \
          "$bazelOut"/vendor/*clang-macos* \
          "$bazelOut"/vendor/*llvm-ifs* \
          "$bazelOut"/vendor/*sysroot-jammy* \
          "$bazelOut"/vendor/*nix_python* \
          "$bazelOut"/vendor/*local_runtime* \
          "$bazelOut"/vendor/rules_python++python+* \
          "$bazelOut"/vendor/rules_python+ \
          "$bazelOut"/external/*clang-linux* \
          "$bazelOut"/external/*clang-macos* \
          "$bazelOut"/external/*llvm-ifs* \
          "$bazelOut"/external/@*llvm-ifs* \
          "$bazelOut"/external/*sysroot-jammy* \
          "$bazelOut"/external/*nix_python* \
          "$bazelOut"/external/@*nix_python* \
          "$bazelOut"/external/*local_runtime* \
          "$bazelOut"/external/@*local_runtime* \
          "$bazelOut"/external/rules_python++python+* \
          "$bazelOut"/external/rules_python+ \
          "$bazelOut"/external/@rules_python+.marker

        for tar in ${pythonStandalone311}/python.tar.gz ${pythonStandalone312}/python.tar.gz ${pythonStandalone313}/python.tar.gz ${pythonStandalone314}/python.tar.gz; do
          sha="$(sha256sum "$tar" | awk '{print $1}')"
          rm -rf "$bazelOut/repository_cache/contents/$sha"
        done
      '';
      # Default installPhase deletes top-level external/ symlinks, but those are
      # the bzlmod repos (they point into repository_cache/). Keep them.
      installPhase = ''
        runHook preInstall

        chmod -R u+w "$bazelOut/external" "$bazelOut/repository_cache" "$bazelOut/vendor" || true

        rm -rf "$bazelOut/external/bazel_tools" "$bazelOut/external/@bazel_tools.marker"
        rm -rf "$bazelOut/external/embedded_jdk" "$bazelOut/external/@embedded_jdk.marker"

        # Recreated from --server_javabase at build time; they point at nix store.
        find "$bazelOut/external" -maxdepth 1 \( \
            -name 'local_*' -o -name '@local_*.marker' \
            -o -name '*+local_jdk' -o -name '*+local_jdk.marker' \
            -o -name '*+local_config_cc' -o -name '*+local_config_cc.marker' \
            -o -name '*+local_config_sh' -o -name '*+local_config_sh.marker' \
            -o -name '*~local_jdk*' -o -name '*~local_config_cc*' -o -name '*~local_config_sh*' \
          \) -exec rm -rf {} +

        find "$bazelOut/external" -name '@*.marker' -exec sh -c 'echo > "$1"' _ {} \;
        find "$bazelOut/external" -type d \( -name .git -o -name .svn -o -name .hg \) -prune -exec rm -rf {} + || true

        find "$bazelOut/external" "$bazelOut/repository_cache" "$bazelOut/vendor" -type l | while read -r symlink; do
          target="$(readlink "$symlink")"
          case "$target" in
            /nix/store/*)
              rm -f "$symlink"
              ;;
            *)
              new_target="$(printf '%s' "$target" | sed "s,$NIX_BUILD_TOP,NIX_BUILD_TOP,")"
              if [ "$new_target" != "$target" ]; then
                ln -sfn "$new_target" "$symlink"
              fi
              ;;
          esac
        done

        find "$bazelOut/external" "$bazelOut/repository_cache" "$bazelOut/vendor" -type f -print0 \
          | xargs -0 -r grep -l '/nix/store/' 2>/dev/null \
          | xargs -r sed -i 's|/nix/store/[a-z0-9]\{32\}-|/nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-|g' \
          || true

        echo '${bazel.name}' > "$bazelOut/external/.nix-bazel-version"

        (cd "$bazelOut" && tar cf "$out" --sort=name --mtime='@1' --owner=0 --group=0 --numeric-owner \
          external/ repository_cache/ vendor/)

        runHook postInstall
      '';
    };

    buildAttrs = {
      doInstallCheck = false;
      dontCheckForBrokenSymlinks = true;
      dontPatchELF = true;
      dontStrip = true;
      preConfigure = ''
                if [ ! -d "$bazelOut/vendor/_registries" ]; then
                  echo "error: vendored BCR metadata missing under $bazelOut/vendor" >&2
                  exit 1
                fi
                # Must be common flags: module resolution runs before build-only flags.
                {
                  echo "common --vendor_dir=$bazelOut/vendor"
                  echo "common --registry=file://$bazelOut/vendor/_registries/bcr.bazel.build"
                } >> local.bazelrc

                # Wrappers hardcode Bazel's http_archive canonical name; we inject clang
                # as local_repository, which uses a different prefix.
                for f in \
                  bazel/internal/cc-toolchain/tools/multi-platform-clang.sh \
                  bazel/internal/cc-toolchain/tools/multi-platform-clang++.sh \
                  bazel/internal/cc-toolchain/tools/linker-driver.sh
                do
                  sed -i 's|+http_archive+clang-|+local_repository+clang-|g' "$f"
                  sed -i 's|+http_archive+llvm-ifs|+local_repository+llvm-ifs|g' "$f"
                  # clang 22 overflows the default 8MiB stack on FlowSensitive templates.
                  sed -i 's/^set -euo pipefail$/set -euo pipefail\nulimit -s unlimited || true/' "$f"
                done

                # Exec/host tools don't always see bazelrc --linkopt. Inject Nix's
                # dynamic linker here so protoc and the like don't segfault in FHS.
                python3 - <<'PY'
        from pathlib import Path
        p = Path("bazel/internal/cc-toolchain/tools/linker-driver.sh")
        text = p.read_text()
        old = '"$clang" "''${linker_args[@]}"'
        new = '"$clang" -Wl,--dynamic-linker,${glibc}/lib/ld-linux-x86-64.so.2 -Wl,-rpath,${nixRpath} "''${linker_args[@]}"'
        if old not in text:
            raise SystemExit("linker-driver exec line not found")
        p.write_text(text.replace(old, new, 1))
        PY

                echo 'build --per_file_copt=crashpad.*\.(cc|cpp)$@-include,stdint.h' >> local.bazelrc
                # clang 22.1.8 SIGSEGV in ASTContext::cleanup at -O2 on this file.
                echo 'build --per_file_copt=NativePDB/.*\\.cpp$@-O0' >> local.bazelrc
      '';
      preBuild = ''
        export GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt"
        export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
        export JAVA_HOME="${jdk21.home}"
        ulimit -s unlimited || true
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/libexec/mojo" "$out/bin"

        execroot="$(find "$bazelOut/execroot" -mindepth 1 -maxdepth 1 -type d | head -n1)"
        if [ -z "$execroot" ]; then
          echo "error: bazel execroot not found under $bazelOut" >&2
          exit 1
        fi

        mojo_bin="$(find "$execroot" -path '*KGEN/tools/mojo/mojo-full' -type f -executable | head -n1)"
        if [ -z "$mojo_bin" ]; then
          echo "error: mojo-full binary not found" >&2
          find "$execroot" -name 'mojo*' -type f | head -n50 >&2 || true
          exit 1
        fi

        # Follow Bazel runfiles that point into $bazelOut. Skip the sysroot and
        # the clang repo: they are link-time only, and sysroot has relative
        # gcc include links that `cp -aL` cannot dereference.
        cp -aL "$mojo_bin" "$out/libexec/mojo/mojo-full"
        if [ -d "$mojo_bin.runfiles" ]; then
          mkdir -p "$out/libexec/mojo/mojo-full.runfiles"
          for e in "$mojo_bin.runfiles"/*; do
            [ -e "$e" ] || continue
            base="$(basename "$e")"
            case "$base" in
              *sysroot-jammy* | *clang-linux* | *clang-macos*)
                continue
                ;;
            esac
            cp -aL "$e" "$out/libexec/mojo/mojo-full.runfiles/$base"
          done
          find "$out/libexec/mojo/mojo-full.runfiles" -xtype l -delete || true
        fi

        mkdir -p "$out/lib"
        find "$out/libexec/mojo/mojo-full.runfiles" \
          \( -name 'libMSupportGlobals.so' -o -name 'libAsyncRTRuntimeGlobals.so' \) -type f \
          | while read -r so; do
            ln -sfn "$so" "$out/lib/$(basename "$so")"
          done

        makeWrapper "$out/libexec/mojo/mojo-full" "$out/bin/mojo" \
          --set-default RUNFILES_DIR "$out/libexec/mojo/mojo-full.runfiles" \
          --prefix LD_LIBRARY_PATH : "$out/lib"

        runHook postInstall
      '';
    };

    requiredSystemFeatures = [ "big-parallel" ];

    passthru = {
      inherit
        clangLinux
        llvmIfs
        sysrootX86
        sysrootAarch
        ;
    };

    meta = {
      description = "Compiler and standard library for a systems language with Python-like syntax";
      longDescription = ''
        Built from the Modular monorepo with `--config=build-mojo`. The C/C++
        toolchain is nixpkgs LLVM 22 and glibc rather than Modular's S3 clang /
        Ubuntu jammy sysroot. Host Python is nixpkgs CPython (rules_python
        hermetic tarball plus local_runtime). The host Bazel is nixpkgs bazel_9.
      '';
      homepage = "https://www.modular.com/mojo";
      changelog = "https://docs.modular.com/mojo/changelog/";
      license = with lib.licenses; [
        asl20
        llvm-exception
      ];
      # C/C++ toolchain is nixpkgs LLVM 22 + glibc. binaryNativeCode remains
      # because the Bazel vendor tarball still contains host tools pulled for
      # analysis (crashpad, buildifier, Go/Node/uv). GPU prebuilts such as
      # nvshmem are not vendored for //KGEN:mojo.
      sourceProvenance = with lib.sourceTypes; [
        fromSource
        binaryNativeCode
      ];
      maintainers = [ lib.maintainers.hnknkm ];
      mainProgram = "mojo";
      platforms = [ "x86_64-linux" ];
    };
  };

  # Bazel runfiles duplicate .so files under _solib_k8 and leave DWARF on the
  # compiler / lld / lldb binaries. Slim here so a layout tweak does not
  # rebuild the 3h compile, and so the public closure is closer to GHC/clang.
  mojoUnwrapped = stdenv.mkDerivation {
    pname = "mojo-unwrapped";
    inherit (mojoCompiled) version;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    dontPatchELF = true;
    dontStrip = true;
    disallowedReferences = [ mojoCompiled ];

    nativeBuildInputs = [
      python3
      file
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall
      cp -a ${mojoCompiled}/. "$out"/
      chmod -R u+w "$out"

      rm -rf "$out/libexec/mojo/mojo-full.runfiles/+local_repository+llvm-ifs"

      python3 - <<'PY'
      import hashlib, os
      root = os.environ["out"]
      by_hash = {}
      for dirpath, _, filenames in os.walk(root):
          for name in filenames:
              path = os.path.join(dirpath, name)
              if os.path.islink(path) or not os.path.isfile(path):
                  continue
              st = os.lstat(path)
              if st.st_nlink > 1 or st.st_size < 4096:
                  continue
              digest = hashlib.sha256()
              with open(path, "rb") as handle:
                  for chunk in iter(lambda: handle.read(1 << 20), b""):
                      digest.update(chunk)
              key = (st.st_size, digest.digest())
              first = by_hash.get(key)
              if first is None:
                  by_hash[key] = path
                  continue
              os.remove(path)
              os.link(first, path)
      PY

      find "$out" -type f -print0 |
        while IFS= read -r -d "" f; do
          if file -b "$f" | grep -q '^ELF '; then
            strip --strip-unneeded "$f" 2>/dev/null || strip "$f" || true
          fi
        done

      mkdir -p "$out/bin" "$out/lib"
      makeWrapper "$out/libexec/mojo/mojo-full" "$out/bin/mojo" \
        --set-default RUNFILES_DIR "$out/libexec/mojo/mojo-full.runfiles" \
        --prefix LD_LIBRARY_PATH : "$out/lib"

      if grep -rqlF '${mojoCompiled}' "$out"; then
        echo "error: slim output still references the fat compile" >&2
        grep -rlF '${mojoCompiled}' "$out" >&2 || true
        exit 1
      fi

      runHook postInstall
    '';

    passthru = {
      inherit (mojoCompiled.passthru)
        clangLinux
        llvmIfs
        sysrootX86
        sysrootAarch
        ;
    };

    meta = mojoCompiled.meta // {
      longDescription = mojoCompiled.meta.longDescription + ''
        The public output strips debug info and hardlinks duplicate Bazel runfiles.
      '';
    };
  };

  # mojo-full looks up std via MODULAR_MOJO_MAX_IMPORT_PATH (Bazel sets this)
  # only for `bazel run`) and compiler-rt via runfiles or this env override.
  # The compiler is Nix-linked (glibc PT_INTERP + rpath), so the public
  # attribute is a regular wrapper rather than buildFHSEnv.
  mojo =
    let
      self = stdenv.mkDerivation {
        pname = "mojo";
        inherit (mojoUnwrapped) version;

        dontUnpack = true;
        dontConfigure = true;
        dontBuild = true;
        dontPatchELF = true;
        dontStrip = true;
        strictDeps = true;
        __structuredAttrs = true;

        nativeBuildInputs = [ makeWrapper ];

        installPhase = ''
          runHook preInstall
          mkdir -p "$out/bin"
          makeWrapper ${mojoUnwrapped}/bin/mojo "$out/bin/mojo" \
            --set-default MODULAR_MOJO_MAX_IMPORT_PATH \
              "${mojoUnwrapped}/libexec/mojo/mojo-full.runfiles/_main/mojo/stdlib/std" \
            --set-default MODULAR_MOJO_MAX_COMPILERRT_PATH \
              "${mojoUnwrapped}/libexec/mojo/mojo-full.runfiles/_main/KGEN/libKGENCompilerRTShared.so" \
            --set-default MODULAR_MOJO_MAX_REPL_ENTRY_POINT \
              "${mojoUnwrapped}/libexec/mojo/mojo-full.runfiles/_main/KGEN/tools/mojo-repl-entry-point/mojo-repl-entry-point" \
            --set-default MODULAR_MOJO_MAX_LLDB_PLUGIN_PATH \
              "${mojoUnwrapped}/libexec/mojo/mojo-full.runfiles/_main/KGEN/libMojoLLDB.so" \
            --set-default MODULAR_MOJO_MAX_LLD_PATH \
              "${mojoUnwrapped}/libexec/mojo/mojo-full.runfiles/+llvm_configure+llvm-project/lld/lld" \
            --set-default MODULAR_CRASH_REPORTING_ENABLED 0 \
            --set-default MODULAR_TELEMETRY_ENABLED 0
          runHook postInstall
        '';

        passthru = {
          unwrapped = mojoUnwrapped;
          tests.hello = runCommand "mojo-hello" { nativeBuildInputs = [ self ]; } ''
            export HOME="$TMPDIR"
            mojo --version
            printf '%s\n' 'def main():' '    print("Hello, Mojo")' > hello.mojo
            mojo hello.mojo | grep -F "Hello, Mojo"
            touch "$out"
          '';
          tests.interpreter = runCommand "mojo-nix-interpreter" { nativeBuildInputs = [ file ]; } ''
            file ${mojoUnwrapped}/libexec/mojo/mojo-full | tee out.txt
            grep -F 'interpreter /nix/store/' out.txt
            grep -F 'glibc-' out.txt
            grep -F 'ld-linux-x86-64.so.2' out.txt
            grep -Fw stripped out.txt
            if grep -q 'interpreter /lib64/' out.txt; then
              echo "error: FHS interpreter" >&2
              exit 1
            fi
            if grep -q 'not stripped' out.txt; then
              echo "error: debug symbols still present" >&2
              exit 1
            fi
            if [ -e ${mojoUnwrapped}/libexec/mojo/mojo-full.runfiles/+local_repository+llvm-ifs ]; then
              echo "error: link-time llvm-ifs repo still in runfiles" >&2
              exit 1
            fi
            touch "$out"
          '';
        };

        meta = mojoUnwrapped.meta // {
          # Avoid the package name; nixpkgs pkgs/README forbids referring to it.
          description = "Compiler and standard library for a systems language with Python-like syntax";
        };
      };
    in
    self;
in
mojo
