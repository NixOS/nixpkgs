{
  stdenv,
  # nix tooling and utilities
  lib,
  fetchurl,
  makeWrapper,
  writeTextFile,
  replaceVars,
  writeShellApplication,
  makeBinaryWrapper,
  autoPatchelfHook,
  buildFHSEnv,
  # this package (through the fixpoint glass)
  # TODO probably still need for tests at some point
  bazel_self,
  # native build inputs
  runtimeShell,
  zip,
  unzip,
  bash,
  coreutils,
  which,
  gawk,
  gnused,
  gnutar,
  gnugrep,
  gzip,
  findutils,
  diffutils,
  gnupatch,
  file,
  installShellFiles,
  lndir,
  python3,
  # Apple dependencies
  cctools,
  libtool,
  sigtool,
  # Allow to independently override the jdks used to build and run respectively
  buildJdk,
  runJdk,
  # Toggle for hacks for running bazel under buildBazelPackage:
  # Always assume all markers valid (this is needed because we remove markers; they are non-deterministic).
  # Also, don't clean up environment variables (so that NIX_ environment variables are passed to compilers).
  enableNixHacks ? false,
  version ? "7.6.0",
}:

let
  sourceRoot = ".";

  src = fetchurl {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
    hash = "sha256-eQKNB38G8ziDuorzoj5Rne/DZQL22meVLrdK0z7B2FI=";
  };

  defaultShellUtils =
    # Keep this list conservative. For more exotic tools, prefer to use
    # @rules_nixpkgs to pull in tools from the nix repository. Example:
    #
    # WORKSPACE:
    #
    #     nixpkgs_git_repository(
    #         name = "nixpkgs",
    #         revision = "def5124ec8367efdba95a99523dd06d918cb0ae8",
    #     )
    #
    #     # This defines an external Bazel workspace.
    #     nixpkgs_package(
    #         name = "bison",
    #         repositories = { "nixpkgs": "@nixpkgs//:default.nix" },
    #     )
    #
    # some/BUILD.bazel:
    #
    #     genrule(
    #        ...
    #        cmd = "$(location @bison//:bin/bison) -other -args",
    #        tools = [
    #            ...
    #            "@bison//:bin/bison",
    #        ],
    #     )
    [
      bash
      coreutils
      diffutils
      file
      findutils
      gawk
      gnugrep
      gnupatch
      gnused
      gnutar
      gzip
      python3
      unzip
      which
      zip
      makeWrapper
    ];

  # Bootstrap an existing Bazel so we can vendor deps with vendor mode
  bazelBootstrap = stdenv.mkDerivation rec {
    name = "bazelBootstrap";

    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel_nojdk-${version}-linux-x86_64";
          hash = "sha256-CYL1paAtzTbfl7TfsqwJry/dkoTO/yZdHrX0NSA1+Ig=";
        }
      else if stdenv.hostPlatform.system == "aarch64-linux" then
        fetchurl {
          url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel_nojdk-${version}-linux-arm64";
          hash = "sha256-6DzTEx218/Qq38eMWvXOX/t9VJDyPczz6Edh4eHdOfg=";
        }
      else if stdenv.hostPlatform.system == "x86_64-darwin" then
        fetchurl {
          url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-darwin-x86_64";
          hash = "sha256-Ut00wXzJezqlvf49RcTjk4Im8j3Qv7R77t1iWpU/HwU=";
        }
      else
        fetchurl {
          # stdenv.hostPlatform.system == "aarch64-darwin"
          url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-darwin-arm64";
          hash = "sha256-ArEXuX0JIa5NT04R0n4sCTA4HfQW43NDXV0EGcaibyQ=";
        };

    nativeBuildInputs = defaultShellUtils;
    buildInputs = [
      stdenv.cc.cc
    ]
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) autoPatchelfHook;

    dontUnpack = true;
    dontPatch = true;
    dontBuild = true;
    dontStrip = true;
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      install -Dm755 $src $out/bin/bazel

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/bazel \
        --prefix PATH : ${lib.makeBinPath nativeBuildInputs}
    '';

    meta.sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  bazelFhs = buildFHSEnv {
    pname = "bazel";
    inherit version;
    targetPkgs = _: [ bazelBootstrap ];
    runScript = "bazel";
  };

  # A FOD that vendors the Bazel dependencies using Bazel's new vendor mode.
  # See https://bazel.build/versions/7.3.0/external/vendor for details.
  # Note that it may be possible to vendor less than the full set of deps in
  # the future, as this is approximately 16GB.
  bazelDeps =
    let
      bazelForDeps = if stdenv.hostPlatform.isDarwin then bazelBootstrap else bazelFhs;
    in
    stdenv.mkDerivation {
      name = "bazelDeps";
      inherit src version;
      sourceRoot = ".";
      patches = [
        # The repo rule that creates a manifest of the bazel source for testing
        # the cli is not reproducible. This patch ensures that it is by sorting
        # the results in the repo rule rather than the downstream genrule.
        ./test_source_sort.patch
      ];
      patchFlags = [
        "--no-backup-if-mismatch"
        "-p1"
      ];
      nativeBuildInputs = [
        unzip
        runJdk
        bazelForDeps
      ]
      ++ lib.optional (stdenv.hostPlatform.isDarwin) libtool;
      configurePhase = ''
        runHook preConfigure

        mkdir bazel_src
        shopt -s dotglob extglob
        mv !(bazel_src) bazel_src
        mkdir vendor_dir

        runHook postConfigure
      '';
      dontFixup = true;
      buildPhase = ''
        runHook preBuild
        export HOME=$(mktemp -d)
        (cd bazel_src; ${bazelForDeps}/bin/bazel --server_javabase=${runJdk} mod deps --curses=no;
        ${bazelForDeps}/bin/bazel --server_javabase=${runJdk} vendor src:bazel_nojdk \
        --curses=no \
        --vendor_dir ../vendor_dir \
        --verbose_failures \
        --experimental_strict_java_deps=off \
        --strict_proto_deps=off \
        --tool_java_runtime_version=local_jdk_21 \
        --java_runtime_version=local_jdk_21 \
        --tool_java_language_version=21 \
        --java_language_version=21)

        # Some post-fetch fixup is necessary, because the deps come with some
        # baggage that is not reproducible. Luckily, this baggage does not factor
        # into the final product, so removing it is enough.

        # the GOCACHE is poisonous!
        rm -rf vendor_dir/gazelle~~non_module_deps~bazel_gazelle_go_repository_cache/gocache

        # as is the go versions file (changes when new versions show up)
        rm -f vendor_dir/rules_go~~go_sdk~go_default_sdk/versions.json

        # and so are .pyc files
        find vendor_dir -name "*.pyc" -type f -delete

        # bazel-external is auto-generated and should be removed
        # see https://bazel.build/external/vendor#vendor-symlinks for more details
        rm vendor_dir/bazel-external

        runHook postBuild
      '';

      installPhase = ''
        mkdir -p $out/vendor_dir
        cp -r --reflink=auto vendor_dir/* $out/vendor_dir
      '';

      outputHashMode = "recursive";
      outputHash =
        if stdenv.hostPlatform.system == "x86_64-linux" then
          "sha256-yKy6IBIkjvN413kFMgkWCH3jAgF5AdpxrVnQyhgfWPA="
        else if stdenv.hostPlatform.system == "aarch64-linux" then
          "sha256-NW/JMVC7k2jBW+d8syMl9L5tDB7SQENJtlMFjAKascI="
        else if stdenv.hostPlatform.system == "aarch64-darwin" then
          "sha256-QVk0Qr86U350oLJ5P50SE6CUYqn5XEqgGCXVf+89wVY="
        else
          # x86_64-darwin
          "sha256-VDrqS9YByYxboF6AcjAR0BRZa5ioGgX1pjx09zPfWTE=";
      outputHashAlgo = "sha256";

    };

  defaultShellPath = lib.makeBinPath defaultShellUtils;

  bashWithDefaultShellUtilsSh = writeShellApplication {
    name = "bash";
    runtimeInputs = defaultShellUtils;
    text = ''
      if [[ "$PATH" == "/no-such-path" ]]; then
        export PATH=${defaultShellPath}
      fi
      exec ${bash}/bin/bash "$@"
    '';
  };

  # Script-based interpreters in shebangs aren't guaranteed to work,
  # especially on MacOS. So let's produce a binary
  bashWithDefaultShellUtils = stdenv.mkDerivation {
    name = "bash";
    src = bashWithDefaultShellUtilsSh;
    nativeBuildInputs = [ makeBinaryWrapper ];
    buildPhase = ''
      makeWrapper ${bashWithDefaultShellUtilsSh}/bin/bash $out/bin/bash
    '';
  };

  platforms = lib.platforms.linux ++ lib.platforms.darwin;

  inherit (stdenv.hostPlatform) isDarwin isAarch64;

  system = if isDarwin then "darwin" else "linux";

  # on aarch64 Darwin, `uname -m` returns "arm64"
  arch = with stdenv.hostPlatform; if isDarwin && isAarch64 then "arm64" else parsed.cpu.name;

  bazelRC = writeTextFile {
    name = "bazel-rc";
    text = ''
      startup --server_javabase=${runJdk}

      # Register nix-specific nonprebuilt java toolchains
      build --extra_toolchains=@bazel_tools//tools/jdk:all
      # and set bazel to use them by default
      build --tool_java_runtime_version=local_jdk
      build --java_runtime_version=local_jdk

      # load default location for the system wide configuration
      try-import /etc/bazel.bazelrc
    '';
  };

in
stdenv.mkDerivation rec {
  pname = "bazel";
  inherit version src;
  inherit sourceRoot;

  patches = [
    # Remote java toolchains do not work on NixOS because they download binaries,
    # so we need to use the @local_jdk//:jdk
    # It could in theory be done by registering @local_jdk//:all toolchains,
    # but these java toolchains still bundle binaries for ijar and stuff. So we
    # need a nonprebult java toolchain (where ijar and stuff is built from
    # sources).
    # There is no such java toolchain, so we introduce one here.
    # By providing no version information, the toolchain will set itself to the
    # version of $JAVA_HOME/bin/java, just like the local_jdk does.
    # To ensure this toolchain gets used, we can set
    # --{,tool_}java_runtime_version=local_jdk and rely on the fact no java
    # toolchain registered by default uses the local_jdk, making the selection
    # unambiguous.
    # This toolchain has the advantage that it can use any ambient java jdk,
    # not only a given, fixed version. It allows bazel to work correctly in any
    # environment where JAVA_HOME is set to the right java version, like inside
    # nix derivations.
    # However, this patch breaks bazel hermeticity, by picking the ambient java
    # version instead of the more hermetic remote_jdk prebuilt binaries that
    # rules_java provide by default. It also requires the user to have a
    # JAVA_HOME set to the exact version required by the project.
    # With more code, we could define java toolchains for all the java versions
    # supported by the jdk as in rules_java's
    # toolchains/local_java_repository.bzl, but this is not implemented here.
    # To recover vanilla behavior, non NixOS users can set
    # --{,tool_}java_runtime_version=remote_jdk, effectively reverting the
    # effect of this patch and the fake system bazelrc.
    ./java_toolchain.patch

    # Bazel integrates with apple IOKit to inhibit and track system sleep.
    # Inside the darwin sandbox, these API calls are blocked, and bazel
    # crashes. It seems possible to allow these APIs inside the sandbox, but it
    # feels simpler to patch bazel not to use it at all. So our bazel is
    # incapable of preventing system sleep, which is a small price to pay to
    # guarantee that it will always run in any nix context.
    #
    # See also ./bazel_darwin_sandbox.patch in bazel_5. That patch uses
    # NIX_BUILD_TOP env var to conditionally disable sleep features inside the
    # sandbox.
    #
    # If you want to investigate the sandbox profile path,
    # IORegisterForSystemPower can be allowed with
    #
    #     propagatedSandboxProfile = ''
    #       (allow iokit-open (iokit-user-client-class "RootDomainUserClient"))
    #     '';
    #
    # I do not know yet how to allow IOPMAssertion{CreateWithName,Release}
    ./darwin_sleep.patch

    # Fix DARWIN_XCODE_LOCATOR_COMPILE_COMMAND by removing multi-arch support.
    # Nixpkgs toolcahins do not support that (yet?) and get confused.
    # Also add an explicit /usr/bin prefix that will be patched below.
    ./xcode_locator.patch

    # On Darwin, the last argument to gcc is coming up as an empty string. i.e: ''
    # This is breaking the build of any C target. This patch removes the last
    # argument if it's found to be an empty string.
    ./trim-last-argument-to-gcc-if-empty.patch

    # --experimental_strict_action_env (which may one day become the default
    # see bazelbuild/bazel#2574) hardcodes the default
    # action environment to a non hermetic value (e.g. "/usr/local/bin").
    # This is non hermetic on non-nixos systems. On NixOS, bazel cannot find the required binaries.
    # So we are replacing this bazel paths by defaultShellPath,
    # improving hermeticity and making it work in nixos.
    (replaceVars ./strict_action_env.patch {
      strictActionEnvPatch = defaultShellPath;
    })

    # bazel reads its system bazelrc in /etc
    # override this path to a builtin one
    (replaceVars ./bazel_rc.patch {
      bazelSystemBazelRCPath = bazelRC;
    })
  ]
  # See enableNixHacks argument above.
  ++ lib.optional enableNixHacks ./nix-build-bazel-package-hacks.patch;

  postPatch =
    let
      darwinPatches = ''
        bazelLinkFlags () {
          eval set -- "$NIX_LDFLAGS"
          local flag
          for flag in "$@"; do
            printf ' -Wl,%s' "$flag"
          done
        }

        # Explicitly configure gcov since we don't have it on Darwin, so autodetection fails
        export GCOV=${coreutils}/bin/false

        # libcxx includes aren't added by libcxx hook
        # https://github.com/NixOS/nixpkgs/pull/41589
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -isystem ${lib.getInclude stdenv.cc.libcxx}/include/c++/v1"
        # for CLang 16 compatibility in external/upb dependency
        export NIX_CFLAGS_COMPILE+=" -Wno-gnu-offsetof-extensions"

        # This variable is used by bazel to propagate env vars for homebrew,
        # which is exactly what we need too.
        export HOMEBREW_RUBY_PATH="foo"

        # don't use system installed Xcode to run clang, use Nix clang instead
        sed -i -E \
          -e "s;/usr/bin/xcrun (--sdk macosx )?clang;${stdenv.cc}/bin/clang $NIX_CFLAGS_COMPILE $(bazelLinkFlags) -framework CoreFoundation;g" \
          -e "s;/usr/bin/codesign;CODESIGN_ALLOCATE=${cctools}/bin/${cctools.targetPrefix}codesign_allocate ${sigtool}/bin/codesign;" \
          scripts/bootstrap/compile.sh \
          tools/osx/BUILD

        # nixpkgs's libSystem cannot use pthread headers directly, must import GCD headers instead
        sed -i -e "/#include <pthread\/spawn.h>/i #include <dispatch/dispatch.h>" src/main/cpp/blaze_util_darwin.cc

        # XXX: What do these do ?
        sed -i -e 's;"/usr/bin/libtool";_find_generic(repository_ctx, "libtool", "LIBTOOL", overriden_tools);g' tools/cpp/unix_cc_configure.bzl
        wrappers=( tools/cpp/osx_cc_wrapper.sh.tpl )
        for wrapper in "''${wrappers[@]}"; do
          sedVerbose $wrapper \
            -e "s,/usr/bin/xcrun install_name_tool,${cctools}/bin/install_name_tool,g"
        done
      '';

      genericPatches = ''
        # unzip builtins_bzl.zip so the contents get patched
        builtins_bzl=src/main/java/com/google/devtools/build/lib/bazel/rules/builtins_bzl
        unzip ''${builtins_bzl}.zip -d ''${builtins_bzl}_zip >/dev/null
        rm ''${builtins_bzl}.zip
        builtins_bzl=''${builtins_bzl}_zip/builtins_bzl

        # md5sum is part of coreutils
        sed -i 's|/sbin/md5|md5sum|g' src/BUILD third_party/ijar/test/testenv.sh

        echo
        echo "Substituting */bin/* hardcoded paths in src/main/java/com/google/devtools"
        # Prefilter the files with grep for speed
        grep -rlZ /bin/ \
          src/main/java/com/google/devtools \
          src/main/starlark/builtins_bzl/common/python \
          tools \
        | while IFS="" read -r -d "" path; do
          # If you add more replacements here, you must change the grep above!
          # Only files containing /bin are taken into account.
          sedVerbose "$path" \
            -e 's!/usr/local/bin/bash!${bashWithDefaultShellUtils}/bin/bash!g' \
            -e 's!/usr/bin/bash!${bashWithDefaultShellUtils}/bin/bash!g' \
            -e 's!/bin/bash!${bashWithDefaultShellUtils}/bin/bash!g' \
            -e 's!/usr/bin/env bash!${bashWithDefaultShellUtils}/bin/bash!g' \
            -e 's!/usr/bin/env python2!${python3}/bin/python!g' \
            -e 's!/usr/bin/env python!${python3}/bin/python!g' \
            -e 's!/usr/bin/env!${coreutils}/bin/env!g' \
            -e 's!/bin/true!${coreutils}/bin/true!g'
        done

        # Fixup scripts that generate scripts. Not fixed up by patchShebangs below.
        sedVerbose scripts/bootstrap/compile.sh \
          -e 's!/bin/bash!${bashWithDefaultShellUtils}/bin/bash!g' \
          -e 's!shasum -a 256!sha256sum!g'

        # Add required flags to bazel command line.
        # XXX: It would suit a bazelrc file better, but I found no way to pass it.
        #      It seems that bazel bootstrapping ignores it.
        #      Passing EXTRA_BAZEL_ARGS is tricky due to quoting.
        sedVerbose compile.sh \
          -e "/bazel_build /a\  --verbose_failures \\\\" \
          -e "/bazel_build /a\  --curses=no \\\\" \
          -e "/bazel_build /a\  --toolchain_resolution_debug='@bazel_tools//tools/jdk:(runtime_)?toolchain_type' \\\\" \
          -e "/bazel_build /a\  --tool_java_runtime_version=local_jdk_21 \\\\" \
          -e "/bazel_build /a\  --java_runtime_version=local_jdk_21 \\\\" \
          -e "/bazel_build /a\  --tool_java_language_version=21 \\\\" \
          -e "/bazel_build /a\  --java_language_version=21 \\\\" \
          -e "/bazel_build /a\  --extra_toolchains=@bazel_tools//tools/jdk:all \\\\" \
          -e "/bazel_build /a\  --vendor_dir=../vendor_dir \\\\" \
          -e "/bazel_build /a\  --repository_disable_download \\\\" \
          -e "/bazel_build /a\  --announce_rc \\\\" \
          -e "/bazel_build /a\  --nobuild_python_zip \\\\" \

        # Also build parser_deploy.jar with bootstrap bazel
        # TODO: Turn into a proper patch
        sedVerbose compile.sh \
          -e 's!bazel_build !bazel_build src/tools/execlog:parser_deploy.jar !' \
          -e 's!clear_log!cp $(get_bazel_bin_path)/src/tools/execlog/parser_deploy.jar output\nclear_log!'

        # append the PATH with defaultShellPath in tools/bash/runfiles/runfiles.bash
        echo "PATH=\$PATH:${defaultShellPath}" >> runfiles.bash.tmp
        cat tools/bash/runfiles/runfiles.bash >> runfiles.bash.tmp
        mv runfiles.bash.tmp tools/bash/runfiles/runfiles.bash

        # reconstruct the now patched builtins_bzl.zip
        pushd src/main/java/com/google/devtools/build/lib/bazel/rules/builtins_bzl_zip &>/dev/null
          zip ../builtins_bzl.zip $(find builtins_bzl -type f) >/dev/null
          rm -rf builtins_bzl
        popd &>/dev/null
        rmdir src/main/java/com/google/devtools/build/lib/bazel/rules/builtins_bzl_zip

        patchShebangs . >/dev/null
      '';
    in
    ''
      function sedVerbose() {
        local path=$1; shift;
        sed -i".bak-nix" "$path" "$@"
        diff -U0 "$path.bak-nix" "$path" | sed "s/^/  /" || true
        rm -f "$path.bak-nix"
      }
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin darwinPatches
    + genericPatches;

  meta = with lib; {
    homepage = "https://github.com/bazelbuild/bazel/";
    description = "Build tool that builds code quickly and reliably";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
    ];
    license = licenses.asl20;
    teams = [ lib.teams.bazel ];
    mainProgram = "bazel";
    inherit platforms;
  };

  # Bazel starts a local server and needs to bind a local address.
  __darwinAllowLocalNetworking = true;

  buildInputs = [
    buildJdk
    bashWithDefaultShellUtils
  ]
  ++ defaultShellUtils;

  # when a command can’t be found in a bazel build, you might also
  # need to add it to `defaultShellPath`.
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    python3
    unzip
    which
    zip
    python3.pkgs.absl-py # Needed to build fish completion
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    cctools
  ];

  # Bazel makes extensive use of symlinks in the WORKSPACE.
  # This causes problems with infinite symlinks if the build output is in the same location as the
  # Bazel WORKSPACE. This is why before executing the build, the source code is moved into a
  # subdirectory.
  # Failing to do this causes "infinite symlink expansion detected"
  preBuildPhases = [ "preBuildPhase" ];
  preBuildPhase = ''
    mkdir bazel_src
    shopt -s dotglob extglob
    mv !(bazel_src) bazel_src
    # Augment bundled repository_cache with our extra paths
    mkdir vendor_dir
    ${lndir}/bin/lndir ${bazelDeps}/vendor_dir vendor_dir
    rm vendor_dir/VENDOR.bazel
    find vendor_dir -maxdepth 1 -type d -printf "pin(\"@@%P\")\n" > vendor_dir/VENDOR.bazel
  '';
  buildPhase = ''
    runHook preBuild
    export HOME=$(mktemp -d)

    # If EMBED_LABEL isn't set, it'd be auto-detected from CHANGELOG.md
    # and `git rev-parse --short HEAD` which would result in
    # "3.7.0- (@non-git)" due to non-git build and incomplete changelog.
    # Actual bazel releases use scripts/release/common.sh which is based
    # on branch/tag information which we don't have with tarball releases.
    # Note that .bazelversion is always correct and is based on bazel-*
    # executable name, version checks should work fine
    export EMBED_LABEL="${version}- (@non-git)"

    echo "Stage 1 - Running bazel bootstrap script"
    ${bash}/bin/bash ./bazel_src/compile.sh

    # XXX: get rid of this, or move it to another stage.
    # It is plain annoying when builds fail.
    echo "Stage 2 - Generate bazel completions"
    ${bash}/bin/bash ./bazel_src/scripts/generate_bash_completion.sh \
        --bazel=./bazel_src/output/bazel \
        --output=./bazel_src/output/bazel-complete.bash \
        --prepend=./bazel_src/scripts/bazel-complete-header.bash \
        --prepend=./bazel_src/scripts/bazel-complete-template.bash
    ${python3}/bin/python3 ./bazel_src/scripts/generate_fish_completion.py \
        --bazel=./bazel_src/output/bazel \
        --output=./bazel_src/output/bazel-complete.fish

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    # official wrapper scripts that searches for $WORKSPACE_ROOT/tools/bazel if
    # it can’t find something in tools, it calls
    # $out/bin/bazel-{version}-{os_arch} The binary _must_ exist with this
    # naming if your project contains a .bazelversion file.
    cp ./bazel_src/scripts/packages/bazel.sh $out/bin/bazel
    versionned_bazel="$out/bin/bazel-${version}-${system}-${arch}"
    mv ./bazel_src/output/bazel "$versionned_bazel"
    wrapProgram "$versionned_bazel" --suffix PATH : ${defaultShellPath}

    mkdir $out/share
    cp ./bazel_src/output/parser_deploy.jar $out/share/parser_deploy.jar
    cat <<EOF > $out/bin/bazel-execlog
    #!${runtimeShell} -e
    ${runJdk}/bin/java -jar $out/share/parser_deploy.jar \$@
    EOF
    chmod +x $out/bin/bazel-execlog

    # shell completion files
    installShellCompletion --bash \
      --name bazel.bash \
      ./bazel_src/output/bazel-complete.bash
    installShellCompletion --zsh \
      --name _bazel \
      ./bazel_src/scripts/zsh_completion/_bazel
    installShellCompletion --fish \
      --name bazel.fish \
      ./bazel_src/output/bazel-complete.fish

    runHook postInstall
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    export TEST_TMPDIR=$(pwd)

    hello_test () {
      $out/bin/bazel test \
        --test_output=errors \
        examples/cpp:hello-success_test \
        examples/java-native/src/test/java/com/example/myproject:hello
    }

    cd ./bazel_src

    # If .bazelversion file is present in dist files and doesn't match `bazel` version
    # running `bazel` command within bazel_src will fail.
    # Let's remove .bazelversion within the test, if present it is meant to indicate bazel version
    # to compile bazel with, not version of bazel to be built and tested.
    rm -f .bazelversion

    # test whether $WORKSPACE_ROOT/tools/bazel works

    mkdir -p tools
    cat > tools/bazel <<"EOF"
    #!${runtimeShell} -e
    exit 1
    EOF

    chmod +x tools/bazel

    # first call should fail if tools/bazel is used
    ! hello_test

    cat > tools/bazel <<"EOF"
    #!${runtimeShell} -e
    exec "$BAZEL_REAL" "$@"
    EOF

    # second call succeeds because it defers to $out/bin/bazel-{version}-{os_arch}
    hello_test

    ## Test that the GSON serialisation files are present
    gson_classes=$(unzip -l $(bazel info install_base)/A-server.jar | grep GsonTypeAdapter.class | wc -l)
    if [ "$gson_classes" -lt 10 ]; then
      echo "Missing GsonTypeAdapter classes in A-server.jar. Lockfile generation will not work"
      exit 1
    fi

    runHook postInstallCheck
  '';

  # Save paths to hardcoded dependencies so Nix can detect them.
  # This is needed because the templates get tar’d up into a .jar.
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${defaultShellPath}" >> $out/nix-support/depends
    # The string literal specifying the path to the bazel-rc file is sometimes
    # stored non-contiguously in the binary due to gcc optimisations, which leads
    # Nix to miss the hash when scanning for dependencies
    echo "${bazelRC}" >> $out/nix-support/depends
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    echo "${cctools}" >> $out/nix-support/depends
  '';

  dontStrip = true;
  dontPatchELF = true;

  # Work around an issue with the old vendored zlib and modern versions
  # of Clang on macOS.
  #
  # Fixed in newer versions of Bazel and rules_java; see
  # <https://github.com/bazelbuild/bazel/issues/25124>.
  #
  # Credit to Homebrew for the hack:
  # <https://github.com/Homebrew/homebrew-core/blob/b61d1f7d7963c08c472d829b25de5d0a06dc4b3d/Formula/b/bazel.rb#L55-L60>
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-fno-define-target-os-macros";

  passthru = {
    # TODO add some tests to cover basic functionality, and also tests for enableNixHacks=true (buildBazelPackage tests)
    # tests = ...

    # For ease of debugging
    inherit bazelDeps bazelFhs bazelBootstrap;
  };
}
