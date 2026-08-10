{
  lib,
  pkgs,
  fetchFromGitHub,
  fetchgit,
  fetchNpmDeps,
  fetchzip,
  gclient2nix,
  nodejs,
  git,
  prefetch-npm-deps,
  makeWrapper,
  patchelf ? null,
  vulkan-loader ? null,
  pciutils ? null,
  libGL ? null,
  buildPackages,
  pkgsBuildBuild,
  pkgsBuildHost,
  stdenv,
  symlinkJoin,
  apple-sdk ? null,
  apple-sdk_15 ? null,
  xcbuild ? null,
  flavor ? "origin",
}:
let
  isOrigin =
    assert lib.assertMsg (builtins.elem flavor [
      "browser"
      "origin"
    ]) "brave-origin flavor must be either \"browser\" or \"origin\"";
    flavor == "origin";
  pkgName = if isOrigin then "brave-origin" else "brave";
  appName = if isOrigin then "Brave Origin" else "Brave Browser";
  serviceKeyPlaceholder = "nixpkgs-${pkgName}-placeholder";
  inherit (stdenv) hostPlatform;
  isLinux = hostPlatform.isLinux;
  isDarwin = hostPlatform.isDarwin;

  # CIPD chromium/gpu/angle-metal-shader-libraries (DEPS checkout_mac).
  angleMetalShaders =
    if isDarwin then
      fetchzip {
        url = "https://chrome-infra-packages.appspot.com/dl/chromium/gpu/angle-metal-shader-libraries/+/S0FPOVKrgaiqyuR20SSHiPorLgYez29bfwEdKBobUMMC";
        # CIPD URLs have no file extension; tell fetchzip this is a zip.
        extension = "zip";
        hash = "sha256-0HLYSAtB+/ACOT5rFzZfpBJef84HKejnXgF+3idQi7U=";
        stripRoot = false;
      }
    else
      null;

  darwinDevtools =
    if isDarwin then
      pkgs.callPackage ./darwin-devtools.nix {
        apple-sdk = pkgs.apple-sdk_15;
        bootstrap_cmds = pkgs.darwin.bootstrap_cmds;
      }
    else
      null;

  sources = import ./source.nix {
    inherit
      lib
      pkgs
      fetchFromGitHub
      fetchgit
      fetchNpmDeps
      gclient2nix
      ;
  };

  chromiumInfo = sources.chromiumInfo;

  mkChromiumDerivation = pkgs.callPackage ./mk-chromium.nix {
    inherit stdenv;
    upstream-info = chromiumInfo;
  };

  xcodeShims =
    if isDarwin then
      pkgs.callPackage ./xcode-shims.nix {
        apple-sdk = pkgs.apple-sdk_15;
        developerDir = darwinDevtools;
        inherit (pkgs) xcbuild;
      }
    else
      null;

  targetCpu =
    {
      "x86_64" = "x64";
      "aarch64" = "arm64";
    }
    .${hostPlatform.parsed.cpu.name};

  rustTools = symlinkJoin {
    name = "${pkgName}-rustTools";
    paths = [
      buildPackages.rust-bindgen
      buildPackages.rustfmt
    ];
  };

  # Matches nixpkgs chromium/common.nix: clang_base_path must point at
  # llvm+cc, not Chromium's bundled toolchain tree.
  llvmCcAndBintools = symlinkJoin {
    name = "${pkgName}-llvmCcAndBintools";
    paths = [
      buildPackages.rustc.llvmPackages.llvm
      buildPackages.rustc.llvmPackages.lld
      buildPackages.rustc.llvmPackages.stdenv.cc
    ];
  };

  overlayInstallCommands = lib.concatStrings (
    lib.mapAttrsToList (name: _value: ''
      echo "Overlaying ${name}..."
      mkdir -p "$(dirname "${name}")"
      rm -rf "${name}"
      cp -r "${sources.braveOverlayDeps.${name}.path}/." "${name}"
      chmod -R u+w "${name}"
    '') sources.braveOverlayEntries
  );

  prefetchNpmDepsBin = lib.getExe prefetch-npm-deps;

  # Brave compiles //brave/chromium_src/<path> instead of <path> when present
  # (macro-injection wrappers). Upstream uses tools/redirect_cc as cc_wrapper;
  # this lightweight Python remapper does the same for ninja builds.
  redirectCc = pkgs.writeShellScript "${pkgName}-redirect-cc" ''
    exec ${lib.getExe buildPackages.python3} ${./redirect-cc.py} "$@"
  '';

in
mkChromiumDerivation (base: rec {
  pname = pkgName;
  inherit (sources.lock) version;

  packageName = pkgName;

  buildTargets = [ "brave" ] ++ lib.optionals isLinux [ "chrome_sandbox" ];

  outputs = [ "out" ] ++ lib.optionals isLinux [ "sandbox" ];

  sandboxExecutableName = "__${pkgName}-suid-sandbox";

  # Keep Chromium third_party/node npm via base.npmRoot/npmDeps + npmConfigHook.
  nativeBuildInputs =
    (base.nativeBuildInputs or [ ])
    ++ [
      nodejs
      git
      makeWrapper
    ]
    ++ lib.optionals isLinux [ patchelf ]
    ++ lib.optionals isDarwin [
      xcodeShims
      xcbuild
      pkgs.darwin.bootstrap_cmds
    ];

  postUnpack =
    (base.postUnpack or "")
    + ''
      ${overlayInstallCommands}
      mkdir -p src/brave/vendor
      # Writable depot_tools copy so we can stub CIPD python bootstrap for nix.
      rm -rf src/brave/vendor/depot_tools
      cp -a ${sources.depotTools}/. src/brave/vendor/depot_tools/
      chmod -R u+w src/brave/vendor/depot_tools
      mkdir -p src/brave/vendor/depot_tools/nix-python
      ln -sfn ${lib.getExe buildPackages.python3} src/brave/vendor/depot_tools/nix-python/python3
      ln -sfn ${lib.getExe buildPackages.python3} src/brave/vendor/depot_tools/nix-python/python
      printf '%s\n' 'nix-python' > src/brave/vendor/depot_tools/python3_bin_reldir.txt
    ''
    + lib.optionalString isDarwin ''
      mkdir -p src/ui/gl/resources/angle-metal
      cp -f ${angleMetalShaders}/gpu_shader_cache.bin src/ui/gl/resources/angle-metal/
    ''
    + ''
      # fetchFromGitHub drops .git; Brave's WDP action lists .git/HEAD as an input.
      mkdir -p src/brave/vendor/web-discovery-project/.git
      echo "${sources.webDiscoveryProjectRev}" > src/brave/vendor/web-discovery-project/.git/HEAD
      # Upstream lock omits resolved URLs; use our regenerated lock + offline cache.
      cp -f ${./web-discovery-project.package-lock.json} src/brave/vendor/web-discovery-project/package-lock.json
      (
        cd src/brave/vendor/web-discovery-project
        echo "Installing web-discovery-project npm deps (offline)"
        export HOME="$TMPDIR"
        export NIX_NODEJS_BUILDNPMPACKAGE=1
        export prefetchNpmDeps="${prefetchNpmDepsBin}"
        export CACHE_MAP_PATH="$TMP/wdp-npm-map"
        npmDeps="${sources.webDiscoveryProjectNpmDeps}" ${prefetchNpmDepsBin} --map-cache
        npmDeps="${sources.webDiscoveryProjectNpmDeps}" ${prefetchNpmDepsBin} --fixup-lockfile "$PWD/package-lock.json"
        cp -r "${sources.webDiscoveryProjectNpmDeps}" "$TMPDIR/wdp-npm-cache"
        chmod -R 700 "$TMPDIR/wdp-npm-cache"
        export npm_config_cache="$TMPDIR/wdp-npm-cache"
        export npm_config_offline=true
        export npm_config_progress=false
        npm ci --ignore-scripts
        patchShebangs node_modules
        # Upstream postinstall: broccoli patch drops broken `esm` require (Node 24).
        ./node_modules/.bin/patch-package
        rm -f "$CACHE_MAP_PATH"
        unset CACHE_MAP_PATH
      )

      # Brave's version.py reads unpatched chrome/VERSION via `git show HEAD:...`.
      (
        cd src
        git init -q
        git config user.email "nixbld@localhost"
        git config user.name "nixbld"
        git add chrome/VERSION
        git commit -qm "nix: import chromium VERSION baseline"
      )

      # GitPatcher can emit status entries without path when repos are incomplete;
      # guard path.join like ffmpeg already does so apply_patches can finish.
      (
        cd src/brave
        sed -i \
          -e "s/v8PatchStatus.forEach((s) => (s.path = path.join('v8', s.path)))/v8PatchStatus.forEach((s) => { if (s.path) s.path = path.join('v8', s.path) })/" \
          -e "s/(s) => (s.path = path.join('third_party', 'catapult', s.path)),/(s) => { if (s.path) s.path = path.join('third_party', 'catapult', s.path) },/" \
          -e "s/(s.path = path.join('third_party', 'devtools-frontend', 'src', s.path)),/((s.path) \&\& (s.path = path.join('third_party', 'devtools-frontend', 'src', s.path))),/" \
          build/commands/lib/util.js
      )

      # Apply Brave patches against pristine Chromium *before* nixpkgs patchPhase.
      (
        cd src/brave
        echo "Installing brave-core npm deps (offline, before Chromium patches)"
        export HOME="$TMPDIR"
        export NIX_NODEJS_BUILDNPMPACKAGE=1
        export prefetchNpmDeps="${prefetchNpmDepsBin}"
        export forceGitDeps=1
        export CACHE_MAP_PATH="$TMP/brave-npm-map"
        npmDeps="${sources.braveNpmDeps}" ${prefetchNpmDepsBin} --map-cache
        npmDeps="${sources.braveNpmDeps}" ${prefetchNpmDepsBin} --fixup-lockfile "$PWD/package-lock.json"
        cp -r "${sources.braveNpmDeps}" "$TMPDIR/brave-npm-cache"
        chmod -R 700 "$TMPDIR/brave-npm-cache"
        export npm_config_cache="$TMPDIR/brave-npm-cache"
        export npm_config_offline=true
        export npm_config_progress=false
        # ignore-scripts: @brave/leo prepare runs before shebangs are patched
        # (/usr/bin/env missing in the sandbox). Generate tokens after patchShebangs.
        npm ci --ignore-scripts
        patchShebangs node_modules
        echo "Installing prebuilt @brave/leo tokens, icons, and react bindings"
        rm -rf node_modules/@brave/leo/tokens node_modules/@brave/leo/icons-skia
        cp -a "${sources.leoTokens}/tokens" "${sources.leoTokens}/icons-skia" node_modules/@brave/leo/
        for d in web-components shared build types react; do
          if [ -d "${sources.leoTokens}/$d" ]; then
            rm -rf "node_modules/@brave/leo/$d"
            cp -a "${sources.leoTokens}/$d" node_modules/@brave/leo/
          fi
        done
        rm -f "$CACHE_MAP_PATH"
        unset CACHE_MAP_PATH

        echo "Applying Brave Chromium patches"
        node ./build/commands/scripts/commands.js apply_patches
      )
    '';

  # npmConfigHook installs Chromium third_party/node; keep Brave npm from postUnpack.
  postPatch =
    (base.postPatch or "")
    + lib.optionalString stdenv.isDarwin ''
      # posix_spawn_file_actions_addchdir is the POSIX name; macOS only has the _np suffix.
      substituteInPlace base/process/launch_mac.cc \
        --replace-fail 'posix_spawn_file_actions_addchdir(' 'posix_spawn_file_actions_addchdir_np('
      # kCGImageByteOrder32Host is not declared in the macOS SDK headers we use;
      # modern macOS is always little-endian so the replacement is correct.
      substituteInPlace skia/ext/skia_utils_mac.mm \
          third_party/blink/renderer/platform/mac/graphics_context_canvas.mm \
        --replace-fail 'kCGImageByteOrder32Host' 'kCGImageByteOrder32Little'
      # anyAppleOS is a future availability platform name not recognised by our SDK.
      substituteInPlace net/base/apple/url_conversions.mm \
        --replace-fail 'anyAppleOS 27.0' 'macOS 14.0'
      # NSScreen.CGDirectDisplayID is a macOS 26+ SDK property; use the classic
      # deviceDescription dictionary key which works on all macOS versions.
      substituteInPlace ui/display/mac/screen_utils_mac.mm \
        --replace-fail 'screen.CGDirectDisplayID' '[[[screen deviceDescription] objectForKey:@"NSScreenNumber"] unsignedIntValue]'
      # NSGlassEffectView is a private class not declared in SDK headers;
      # look it up dynamically so the compiler does not reject the reference.
      substituteInPlace components/remote_cocoa/app_shim/native_widget_ns_window_bridge.mm \
        --replace-fail '[NSGlassEffectView class]' 'NSClassFromString(@"NSGlassEffectView")'
    ''
    + ''

      # nixpkgs chromium already links rustc here for M149+; Brave's
      # tools/crates/build_crate.gni also requires cargo as an action input.
      mkdir -p third_party/rust-toolchain/bin
      ln -sfn "${buildPackages.rustc}/bin/rustc" third_party/rust-toolchain/bin/rustc
      ln -sfn "${lib.getExe' buildPackages.cargo "cargo"}" third_party/rust-toolchain/bin/cargo

      # tools/crates/vendor and wasm vendor restores...
      # patchShebangs rewrites vendored crate sources and breaks `cargo --frozen`
      # checksums used by //brave/tools/crates and //brave/third_party/wasm.
      rm -rf brave/tools/crates/vendor
      cp -a "${sources.braveCore}/tools/crates/vendor" brave/tools/crates
      chmod -R u+w brave/tools/crates/vendor
      rm -rf brave/third_party/wasm/vendor
      cp -a "${sources.braveCore}/third_party/wasm/vendor" brave/third_party/wasm
      chmod -R u+w brave/third_party/wasm/vendor
    ''
    + lib.optionalString isDarwin ''
          # nix cc-wrapper rejects --target=*-apple-macos; Chromium emits that triple.
          # Prefer apple-darwin so any remaining wrapped tools agree with the host.
          substituteInPlace build/config/mac/BUILD.gn \
            --replace-fail '--target=$clang_arch-apple-macos' '--target=$clang_arch-apple-darwin'

          # Chromium's pkg-config.py returns empty results on non-Linux so Linux
          # unbundle shims (libxml/flac/...) get no -isystem/-l flags on Darwin.
          substituteInPlace build/config/linux/pkg-config.py \
            --replace-fail 'if "linux" not in sys.platform:' 'if "linux" not in sys.platform and "darwin" not in sys.platform:'

          # On Mac, sysroot is the SDK path. pkg-config.py's RewritePath then wrongly
          # maps /nix/store/... -> $SDK/nix/store/.... Keep nix store paths absolute.
          python3 - <<'PY'
      from pathlib import Path
      p = Path("build/config/linux/pkg-config.py")
      text = p.read_text()
      old = "def RewritePath(path, strip_prefix, sysroot):"
      new = "def RewritePath(path, strip_prefix, sysroot):\n  if path.startswith('/nix/'):\n    return path"
      p.write_text(text.replace(old, new, 1))
      PY

          # With -isysroot, Darwin clang remaps absolute -isystem/-L under the SDK.
          # Always rebase pkg-config paths to the build dir so they stay outside
          # the sysroot (same as Chromium does when use_sysroot is true).
          python3 - <<'PY'
      from pathlib import Path
      p = Path("build/config/linux/pkg_config.gni")
      text = p.read_text()
      old = "if (_pkg_config_requires_abs_path && (use_sysroot || use_remoteexec)) {"
      new = "if (_pkg_config_requires_abs_path) {"
      if old not in text:
          raise SystemExit(f"{p}: expected rebase condition not found")
      text = text.replace(old, new, 1)
      old_libs = """    if (!defined(invoker.ignore_libs) || !invoker.ignore_libs) {
            libs = pkgresult[2]
            lib_dirs = pkgresult[3]
          }"""
      # GN forbids reassigning a nonempty list; build lib_dirs from scratch.
      new_libs = """    if (!defined(invoker.ignore_libs) || !invoker.ignore_libs) {
            libs = pkgresult[2]
            lib_dirs = []
            foreach(_lib_dir, pkgresult[3]) {
              if (_pkg_config_requires_abs_path) {
                lib_dirs += [ rebase_path(_lib_dir, root_build_dir) ]
              } else {
                lib_dirs += [ _lib_dir ]
              }
            }
          }"""
      if old_libs not in text:
          raise SystemExit(f"{p}: expected lib_dirs block not found")
      p.write_text(text.replace(old_libs, new_libs, 1))
      print(f"patched {p} for Darwin pkg-config path rebasing")
      PY

          # wasm-opt-sys's cc::Build::is_flag_supported("-std=c++17") falsely fails under
          # nix's clang wrapper in the Chromium build env; skip the probe and refresh
          # the cargo-frozen file checksum.
          substituteInPlace brave/tools/crates/vendor/wasm-opt-sys/build.rs \
            --replace-fail 'if !builder.is_flag_supported(cxx17_flag)?' 'if false && !builder.is_flag_supported(cxx17_flag)?'
          python3 - <<'PY'
      from pathlib import Path
      import hashlib, json
      root = Path("brave/tools/crates/vendor/wasm-opt-sys")
      checksum_path = root / ".cargo-checksum.json"
      data = json.loads(checksum_path.read_text())
      rel = "build.rs"
      data["files"][rel] = hashlib.sha256((root / rel).read_bytes()).hexdigest()
      checksum_path.write_text(json.dumps(data, separators=(",", ":"), sort_keys=True) + "\n")
      print(f"updated {checksum_path} files[{rel}]={data['files'][rel]}")
      PY
    ''
    + ''

      # wasm-pack runs `cargo metadata` without --config/--frozen, and Cargo
      # config discovery walks from out/Release. Place a source-root config so
      # crates.io is redirected to Brave's vendored wasm crates.
      mkdir -p .cargo
      printf '%s\n' \
        '[source.crates-io]' \
        'replace-with = "vendored-sources"' \
        '[source.vendored-sources]' \
        'directory = "brave/third_party/wasm/vendor"' \
        > .cargo/config.toml

      # We only build the browser binary, not dist packages. Brave's create_dist
      # pulls //chrome/installer/linux which requires a non-empty sysroot that
      # nixpkgs deliberately leaves empty (use_sysroot=false).
      python3 - <<'PY'
      from pathlib import Path
      p = Path("brave/BUILD.gn")
      text = p.read_text()
      needle = '"//chrome/installer/linux:$linux_channel",'
      if needle in text:
          p.write_text(text.replace(needle, f"# nixpkgs: skipped {needle}", 1))
      else:
          print(f"{p}: installer/linux dep already absent (ok)")
      PY

      # Ensure Brave's v8 patches take effect. GitPatcher expects a nested
      # v8/.git; without it, appliesTo can be empty and //brave/chromium_src/v8
      # never lands on include_dirs (breaks Page Graph isolate wrappers).
      python3 - <<'PY'
      from pathlib import Path

      p = Path("v8/BUILD.gn")
      text = p.read_text()
      marker = "//brave/chromium_src/v8"
      if marker not in text:
          needle = 'config("internal_config_base")'
          idx = text.find(needle)
          if idx < 0:
              raise SystemExit(f"{p}: missing {needle}")
          next_config = text.find("\nconfig(", idx + len(needle))
          region_end = next_config if next_config > 0 else len(text)
          inc = text.find("include_dirs = [", idx, region_end)
          if inc < 0:
              raise SystemExit(f"{p}: missing include_dirs in internal_config_base")
          end = text.find("]", inc, region_end)
          if end < 0:
              raise SystemExit(f"{p}: unclosed include_dirs in internal_config_base")
          insert = (
              "\n  _include_dirs = include_dirs\n"
              "  include_dirs = []\n"
              f'  include_dirs = [ "{marker}" ] + _include_dirs'
          )
          text = text[: end + 1] + insert + text[end + 1 :]
          print(f"{p}: injected {marker} include_dirs")

      if "brave/v8/sources.gni" not in text:
          hs = 'v8_header_set("v8_headers")'
          i = text.find(hs)
          if i < 0:
              raise SystemExit(f"{p}: missing {hs}")
          j = text.find('":v8_version",', i)
          if j < 0:
              raise SystemExit(f"{p}: missing :v8_version in v8_headers")
          k = text.find("]", j)
          insert2 = (
              '\n  import("//brave/v8/sources.gni")\n'
              "  sources += brave_v8_headers_sources\n"
              "  public_deps += brave_v8_headers_public_deps"
          )
          text = text[: k + 1] + insert2 + text[k + 1 :]
          print(f"{p}: injected brave/v8/sources.gni")

      p.write_text(text)
      if marker not in p.read_text():
          raise SystemExit(f"{p}: failed to persist {marker}")

      # patches/v8/src-codegen-compiler.cc.patch
      cc = Path("v8/src/codegen/compiler.cc")
      cc_text = cc.read_text()
      macro = "BRAVE_COMPILER_GET_FUNCTION_FROM_EVAL"
      if macro not in cc_text:
          anchor = "CHECK(is_compiled_scope.is_compiled());"
          if anchor not in cc_text:
              raise SystemExit(f"{cc}: missing {anchor!r}")
          cc.write_text(
              cc_text.replace(
                  anchor,
                  anchor + f"\n  {macro}",
                  1,
              )
          )
          print(f"{cc}: injected {macro}")
      PY

      # Re-apply nested-repo Brave patches. Same .git gap as v8: GitPatcher targets
      # third_party/*/ as separate repos; nixpkgs chromium has no nested .git.
      reapply_nested_brave_patches() {
        local patch_dir="$1"
        local repo_dir="$2"
        local label="$3"
        if [ ! -d "$patch_dir" ] || [ ! -d "$repo_dir" ]; then
          echo "skip nested patches $label (missing $patch_dir or $repo_dir)"
          return 0
        fi
        echo "Re-applying Brave $label patches into $repo_dir"
        (
          cd "$repo_dir"
          shopt -s nullglob
          for p in "$patch_dir"/*.patch; do
            if patch -p1 --dry-run -s < "$p" >/dev/null 2>&1; then
              patch -p1 -s < "$p"
              echo "  applied $(basename "$p")"
            else
              echo "  skip $(basename "$p") (already applied or mismatch)"
            fi
          done
        )
      }
      reapply_nested_brave_patches \
        "$PWD/brave/patches/third_party/search_engines_data/resources" \
        "$PWD/third_party/search_engines_data/resources" \
        search_engines_data
      reapply_nested_brave_patches \
        "$PWD/brave/patches/third_party/ffmpeg" \
        "$PWD/third_party/ffmpeg" \
        ffmpeg
      reapply_nested_brave_patches \
        "$PWD/brave/patches/third_party/catapult" \
        "$PWD/third_party/catapult" \
        catapult
      reapply_nested_brave_patches \
        "$PWD/brave/patches/third_party/devtools-frontend/src" \
        "$PWD/third_party/devtools-frontend/src" \
        devtools-frontend

      # Brave removes Chromium's duckduckgo/qwant entries so brave_prepopulated_engines
      # can own those symbols. Enforce after nested re-apply.
      python3 - <<'PY'
      from pathlib import Path

      def remove_engine_object(text: str, key: str) -> tuple[str, bool]:
          needle = f'"{key}"'
          start = text.find(needle)
          if start < 0:
              return text, False
          # Walk back over whitespace/comma to include the preceding separator.
          cut_start = start
          while cut_start > 0 and text[cut_start - 1] in " \t\r\n":
              cut_start -= 1
          if cut_start > 0 and text[cut_start - 1] == ",":
              cut_start -= 1
          # Find opening brace after "key":
          brace = text.find("{", start)
          if brace < 0:
              raise SystemExit(f"no object for engine {key}")
          depth = 0
          i = brace
          while i < len(text):
              c = text[i]
              if c == "{":
                  depth += 1
              elif c == "}":
                  depth -= 1
                  if depth == 0:
                      end = i + 1
                      # Drop a trailing comma if we did not consume a leading one.
                      j = end
                      while j < len(text) and text[j] in " \t\r\n":
                          j += 1
                      if text[cut_start:start].find(",") < 0 and j < len(text) and text[j] == ",":
                          end = j + 1
                      return text[:cut_start] + text[end:], True
              i += 1
          raise SystemExit(f"unclosed object for engine {key}")

      p = Path("third_party/search_engines_data/resources/definitions/prepopulated_engines.json")
      text = p.read_text()
      removed = []
      for key in ("duckduckgo", "qwant"):
          text, did = remove_engine_object(text, key)
          if did:
              removed.append(key)
      if removed:
          p.write_text(text)
          print(f"{p}: removed upstream engines {removed}")
      if '"duckduckgo"' in text or '"qwant"' in text:
          raise SystemExit(f"{p}: duckduckgo/qwant still present after cleanup")
      print(f"{p}: duckduckgo/qwant absent (good)")
      PY
    '';

  preConfigure = (base.preConfigure or "") + ''
    cd brave
    export is_brave_origin_branded=${if isOrigin then "true" else "false"}
    export brave_services_key=${serviceKeyPlaceholder}
    export service_key_stt=${serviceKeyPlaceholder}
    export service_key_search=${serviceKeyPlaceholder}
    export service_key_aichat=${serviceKeyPlaceholder}
    # prepare_only updates branding/touched files but intentionally skips gn gen.
    node ./build/commands/scripts/commands.js build Release --prepare_only
    python3 ./build/util/version.py gen ../chrome/VERSION
    cd ..
  '';

  # Brave's build commands put these on PYTHONPATH so patched Chromium scripts
  # can `import brave_chromium_utils` (see brave/build/commands/lib/config.ts).
  preBuild = (base.preBuild or "") + ''
    export PYTHONPATH="$PWD/brave/script:$PWD/tools/grit/grit/extern:$PWD/brave/vendor/requests:$PWD/brave/third_party/cryptography:$PWD/brave/third_party/macholib:$PWD/build:$PWD/third_party/depot_tools''${PYTHONPATH:+:$PYTHONPATH}"
    export PYTHONUNBUFFERED=1

    # Force cargo offline + vendored wasm crates for wasm-pack's `cargo metadata`
    # (which does not receive --config/--frozen from rust_to_wasm.gni).
    export CARGO_HOME="$TMPDIR/cargo-home"
    mkdir -p "$CARGO_HOME"
    printf '%s\n' \
      '[source.crates-io]' \
      'replace-with = "vendored-sources"' \
      '[source.vendored-sources]' \
      "directory = \"$PWD/brave/third_party/wasm/vendor\"" \
      '[net]' \
      'offline = true' \
      > "$CARGO_HOME/config.toml"
    export CARGO_NET_OFFLINE=true
  '';

  # Write Brave args.gn ourselves: prepare_only skips generateNinjaFiles, and
  # nixpkgs' default configurePhase would overwrite args with --args=.
  configurePhase = ''
    runHook preConfigure

    libExecPath="$out/libexec/${packageName}"

    ${lib.optionalString isLinux ''
      python3 build/linux/unbundle/replace_gn_files.py --system-libraries flac libjpeg libxml libxslt
    ''}
    ${lib.optionalString isDarwin ''
      # Chromium source from nixpkgs omits bundled flac/etc. (Linux unbundles them).
      # Use the same system-library shims on Darwin via pkg-config.
      python3 build/linux/unbundle/replace_gn_files.py --system-libraries flac libjpeg libxml libxslt
      export SDKROOT="${darwinDevtools}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
      export DEVELOPER_DIR="${darwinDevtools}"
      # Prefer bootstrap_cmds (mig) before toolchain stubs; keep xcode shims.
      export PATH="${darwinDevtools}/bootstrap_cmds/bin:${darwinDevtools}/Toolchains/XcodeDefault.xctoolchain/usr/bin:${xcodeShims}/bin:$PATH"
      # Leave mac_sdk_path unset: with use_system_xcode, Chromium's
      # //build/config/apple/sdk_info.py symlinks the SDK under
      # $root_build_dir/sdk/xcode_links so //build/config/mac:sdk_inputs can
      # declare .defs files as outputs inside the build directory.
    ''}

    mkdir -p out/Release
    cat > out/Release/args.gn <<EOF
    import("//brave/build/args/brave_defaults.gni")
    import("//brave/build/args/blink_platform_defaults.gni")
    import("//brave/build/args/${
      if isOrigin then "brave_origin/branding_defaults" else "branding_defaults"
    }.gni")
    import("//brave/build/args/desktop_defaults.gni")

    is_official_build = true
    is_debug = false
    is_component_build = false
    target_cpu = "${targetCpu}"
    # Brave stable is the empty string; "release" is not a valid channel name.
    brave_channel = ""
    enable_hangout_services_extension = false
    skip_signing = true
    is_brave_origin_branded = ${if isOrigin then "true" else "false"}

    brave_services_key = "${serviceKeyPlaceholder}"
    service_key_stt = "${serviceKeyPlaceholder}"
    service_key_search = "${serviceKeyPlaceholder}"
    service_key_aichat = "${serviceKeyPlaceholder}"

    ${
      if isLinux then
        ''
          custom_toolchain = "//build/toolchain/linux/unbundle:default"
          host_toolchain = "//build/toolchain/linux/unbundle:default"
          host_pkg_config = "${pkgsBuildBuild.pkg-config}/bin/pkg-config"
          pkg_config = "${pkgsBuildHost.pkg-config}/bin/${stdenv.cc.targetPrefix}pkg-config"
          use_sysroot = false
          use_gio = true
          use_cups = true
          use_pulseaudio = true
          link_pulseaudio = true
          rtc_use_pipewire = true
        ''
      else
        ''
          use_system_xcode = true
          use_sysroot = false
          use_gio = false
          use_cups = false
          rtc_use_pipewire = false
          enable_stripping = false
          # Skip CIPD Sparkle binaries (not fetched by gclient2nix); nix users update via nix.
          enable_sparkle = false
          host_pkg_config = "${pkgsBuildBuild.pkg-config}/bin/pkg-config"
          pkg_config = "${pkgsBuildHost.pkg-config}/bin/pkg-config"
          # nixpkgs ld64.lld is older than Chromium's hermetic LLD (no --read-workers).
          enable_lld_read_workers = false
          # Avoid hermetic tools/clang/dsymutil (not in chromium src tarball).
          enable_dsyms = false
          # Match nixpkgs Darwin stdenv (libraries are built with minos 14.0).
          mac_deployment_target = "14.0"
          mac_min_system_version = "14.0"
          # Metal toolchain (`xcrun metal`) is not in apple-sdk; keep GL backend.
          angle_enable_metal = false
        ''
    }

    treat_warnings_as_errors = false
    clang_use_chrome_plugins = false
    symbol_level = 0
    blink_symbol_level = 0
    ${lib.optionalString isLinux "use_system_libffi = true"}
    clang_warning_suppression_file = ""
    clang_base_path = "${llvmCcAndBintools}"
    use_clang_modules = false
    use_unified_system_module = false
    chrome_pgo_phase = 0
    disable_fieldtrial_testing_config = true
    google_api_key = "AIzaSyDGi15Zwl11UNe6Y-5XW_upsfyw31qwZPI"
    use_qt5 = false
    use_qt6 = false

    # Use nixpkgs Rust instead of //third_party/rust-toolchain
    enable_rust = true
    rust_sysroot_absolute = "${buildPackages.rustc}"
    rust_bindgen_root = "${rustTools}"
    rustc_version = "${buildPackages.rustc.version}"

    # Remap crypto/*.cc (etc.) to brave/chromium_src overrides.
    cc_wrapper = "${redirectCc}"
    EOF

    gn gen out/Release | tee gn-gen-outputs.txt
    if grep -o WARNING gn-gen-outputs.txt; then
      echo "Found gn WARNING, exiting nix build" >&2
      exit 1
    fi

    runHook postConfigure
  '';

  gnFlags = { };

  # Chromium expects nightly/bleeding-edge rustc features; nixpkgs stable
  # rustc needs RUSTC_BOOTSTRAP like the chromium derivation.
  env = (base.env or { }) // {
    RUSTC_BOOTSTRAP = 1;
  };

  installPhase = ''
    runHook preInstall

    ${
      if isLinux then
        ''
          mkdir -p "$libExecPath"
          cp -v "$buildPath/"*.so "$buildPath/"*.pak "$buildPath/"*.bin "$libExecPath/" 2>/dev/null || true
          cp -v "$buildPath/libvulkan.so.1" "$libExecPath/" 2>/dev/null || true
          cp -v "$buildPath/vk_swiftshader_icd.json" "$libExecPath/" 2>/dev/null || true
          cp -v "$buildPath/icudtl.dat" "$libExecPath/"
          cp -vLR "$buildPath/locales" "$buildPath/resources" "$libExecPath/"
          cp -v "$buildPath/chrome_crashpad_handler" "$libExecPath/"
          cp -v "$buildPath/brave" "$libExecPath/${pkgName}"

          if [ -n "$(find "$buildPath/swiftshader/" -maxdepth 1 -name '*.so' -print -quit 2>/dev/null)" ]; then
            mkdir -p "$libExecPath/swiftshader"
            cp -v "$buildPath/swiftshader/"*.so "$libExecPath/swiftshader/"
          fi

          mkdir -p "$sandbox/bin"
          cp -v "$buildPath/chrome_sandbox" "$sandbox/bin/${sandboxExecutableName}"

          mkdir -p "$out/bin"
          makeWrapper "$libExecPath/${pkgName}" "$out/bin/${pkgName}" \
            --set CHROME_DEVEL_SANDBOX "$sandbox/bin/${sandboxExecutableName}"
        ''
      else
        ''
          mkdir -p "$out/Applications" "$out/bin"
          appSource=
          for candidate in \
            "$buildPath/Brave Browser.app" \
            "$buildPath/Brave Origin.app" \
            "$buildPath/"*.app
          do
            if [ -d "$candidate" ]; then
              appSource="$candidate"
              break
            fi
          done
          if [ -z "$appSource" ]; then
            echo "error: no .app bundle found under $buildPath" >&2
            ls -la "$buildPath" >&2 || true
            exit 1
          fi
          cp -R "$appSource" "$out/Applications/${appName}.app"
          makeWrapper "$out/Applications/${appName}.app/Contents/MacOS/${appName}" \
            "$out/bin/${pkgName}" \
            || makeWrapper "$(find "$out/Applications/${appName}.app/Contents/MacOS" -type f -perm -111 | head -1)" \
              "$out/bin/${pkgName}"
        ''
    }

    runHook postInstall
  '';

  postFixup =
    (base.postFixup or "")
    + lib.optionalString isLinux ''
      for chromiumBinary in "$libExecPath/${pkgName}" "$libExecPath/libGLESv2.so"; do
        if [ -f "$chromiumBinary" ]; then
          patchelf \
            --set-rpath "${
              lib.makeLibraryPath [
                libGL
                vulkan-loader
                pciutils
              ]
            }:$(patchelf --print-rpath "$chromiumBinary" 2>/dev/null || true)" \
            "$chromiumBinary" || true
        fi
      done
    '';

  passthru = {
    inherit (sources) lock;
    pinnedSrc = pkgs.callPackage ./src-package.nix { };
    updateScript = ./update.sh;
  };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description =
      if isOrigin then
        "Privacy-oriented Brave Origin browser built from source"
      else
        "Privacy-oriented Brave browser built from source";
    homepage = if isOrigin then "https://brave.com/origin/" else "https://brave.com/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      uskudnik
      jefflabonte
      nasirhm
      buckley310
      rachalaraj
      mio-19
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = pkgName;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    timeout = 172800;
  };
})
