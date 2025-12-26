{
  stdenv,
  lib,
  fetchpatch,
  zstd,
  fetchFromGitiles,
  fetchNpmDeps,
  buildPackages,
  pkgsBuildBuild,
  # Channel data:
  upstream-info,
  # Helper functions:
  chromiumVersionAtLeast,
  versionRange,

  # Native build inputs:
  ninja,
  bashInteractive,
  pkg-config,
  python3,
  perl,
  nodejs,
  npmHooks,
  which,
  libuuid,
  overrideCC,
  # postPatch:
  pkgsBuildHost,
  # configurePhase:
  gnChromium,
  symlinkJoin,

  # Build inputs:
  libpng,
  bzip2,
  flac,
  speex,
  libopus,
  libevent,
  expat,
  libjpeg,
  snappy,
  libcap,
  minizip,
  libwebp,
  libusb1,
  re2,
  ffmpeg,
  libxslt,
  libxml2,
  nasm,
  nspr,
  nss,
  util-linux,
  alsa-lib,
  bison,
  gperf,
  libkrb5,
  glib,
  gtk3,
  dbus-glib,
  libXScrnSaver,
  libXcursor,
  libXtst,
  libxshmfence,
  libGLU,
  libGL,
  dri-pkgconfig-stub,
  libgbm,
  pciutils,
  protobuf,
  speechd-minimal,
  libXdamage,
  at-spi2-core,
  pipewire,
  libva,
  libdrm,
  wayland,
  libxkbcommon, # Ozone
  curl,
  libffi,
  libepoxy,
  libevdev,
  # postPatch:
  glibc, # gconv + locale
  # postFixup:
  vulkan-loader,

  # Package customization:
  cupsSupport ? true,
  cups ? null,
  proprietaryCodecs ? true,
  pulseSupport ? false,
  libpulseaudio ? null,
  ungoogled ? false,
  ungoogled-chromium,
  # Optional dependencies:
  libgcrypt ? null, # cupsSupport
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
  systemdLibs,
}:

buildFun:

let
  python3WithPackages = python3.pythonOnBuildForHost.withPackages (
    ps: with ps; [
      ply
      jinja2
      setuptools
    ]
  );

  # The additional attributes for creating derivations based on the chromium
  # source tree.
  extraAttrs = buildFun base;

  githubPatch =
    {
      commit,
      hash,
      revert ? false,
      excludes ? [ ],
    }:
    fetchpatch {
      url = "https://github.com/chromium/chromium/commit/${commit}.patch";
      inherit hash revert excludes;
    };

  mkGnFlags =
    let
      # Serialize Nix types into GN types according to this document:
      # https://source.chromium.org/gn/gn/+/master:docs/language.md
      mkGnString = value: "\"${lib.escape [ "\"" "$" "\\" ] value}\"";
      sanitize =
        value:
        if value == true then
          "true"
        else if value == false then
          "false"
        else if lib.isList value then
          "[${lib.concatMapStringsSep ", " sanitize value}]"
        else if lib.isInt value then
          toString value
        else if lib.isString value then
          mkGnString value
        else
          throw "Unsupported type for GN value `${value}'.";
      toFlag = key: value: "${key}=${sanitize value}";
    in
    attrs: lib.concatStringsSep " " (lib.attrValues (lib.mapAttrs toFlag attrs));

  # https://source.chromium.org/chromium/chromium/src/+/master:build/linux/unbundle/replace_gn_files.py
  gnSystemLibraries = [
    # TODO:
    # "ffmpeg"
    # "snappy"
    "flac"
    "libjpeg"
  ]
  ++ lib.optionals needsLibpng [
    "libpng"
  ]
  ++ [
    # Use the vendored libwebp for M124+ until we figure out how to solve:
    # Running phase: configurePhase
    # ERROR Unresolved dependencies.
    # //third_party/libavif:libavif_enc(//build/toolchain/linux/unbundle:default)
    #   needs //third_party/libwebp:libwebp_sharpyuv(//build/toolchain/linux/unbundle:default)
    # "libwebp"
    "libxml"
    "libxslt" # depends on libxml, always remove or re-add as a pair
    # "opus"
  ];

  # build paths and release info
  packageName = extraAttrs.packageName or extraAttrs.name;
  buildType = "Release";
  buildPath = "out/${buildType}";
  libExecPath = "$out/libexec/${packageName}";

  ungoogler = ungoogled-chromium {
    inherit (upstream-info.deps.ungoogled-patches) rev hash;
  };

  # There currently isn't a (much) more concise way to get a stdenv
  # that uses lld as its linker without bootstrapping pkgsLLVM; see
  # https://github.com/NixOS/nixpkgs/issues/142901
  buildPlatformLlvmStdenv =
    let
      llvmPackages = pkgsBuildBuild.rustc.llvmPackages;
    in
    overrideCC llvmPackages.stdenv (
      llvmPackages.stdenv.cc.override {
        inherit (llvmPackages) bintools;
      }
    );

  chromiumRosettaStone = {
    cpu =
      platform:
      let
        name = platform.parsed.cpu.name;
      in
      (
        {
          "x86_64" = "x64";
          "i686" = "x86";
          "arm" = "arm";
          "aarch64" = "arm64";
        }
        .${platform.parsed.cpu.name} or (throw "no chromium Rosetta Stone entry for cpu: ${name}")
      );
    os =
      platform:
      if platform.isLinux then
        "linux"
      else
        throw "no chromium Rosetta Stone entry for os: ${platform.config}";
  };

  isElectron = packageName == "electron";
  rustcVersion = buildPackages.rustc.version;
  # libpng has been replaced by the png rust crate
  # https://github.com/image-rs/image-png/discussions/562
  needsLibpng = !chromiumVersionAtLeast "143";

  chromiumDeps = lib.mapAttrs (
    path: args:
    fetchFromGitiles (
      removeAttrs args [ "recompress" ]
      // lib.optionalAttrs args.recompress or false {
        name = "source.tar.zstd";
        downloadToTemp = false;
        passthru.unpack = true;
        nativeBuildInputs = [ zstd ];
        postFetch = ''
          tar \
            --use-compress-program="zstd -T$NIX_BUILD_CORES" \
            --sort=name \
            --mtime="1970-01-01" \
            --owner=root --group=root \
            --numeric-owner --mode=go=rX,u+rw,a-s \
            --remove-files \
            --directory="$out" \
            -cf "$TMPDIR/source.zstd" .
          mv "$TMPDIR/source.zstd" "$out"
        '';
      }
    )
  ) upstream-info.DEPS;

  unpackPhaseSnippet = lib.concatStrings (
    lib.mapAttrsToList (
      path: dep:
      (
        if dep.unpack or false then
          ''
            mkdir -p ${path}
            pushd ${path}
            unpackFile ${dep}
            popd
          ''
        else
          ''
            mkdir -p ${dirOf path}
            cp -r ${dep}/. ${path}
          ''
      )
      + ''
        chmod u+w -R ${path}
      ''
    ) chromiumDeps
  );

  base = rec {
    pname = "${lib.optionalString ungoogled "ungoogled-"}${packageName}-unwrapped";
    inherit (upstream-info) version;
    inherit packageName buildType buildPath;

    unpackPhase = ''
      runHook preUnpack

      ${unpackPhaseSnippet}
      sourceRoot=src

      runHook postUnpack
    '';

    npmRoot = "third_party/node";
    npmDeps =
      (fetchNpmDeps {
        src = chromiumDeps."src";
        sourceRoot = npmRoot;
        hash = upstream-info.deps.npmHash;
      }).overrideAttrs
        (p: {
          nativeBuildInputs = p.nativeBuildInputs or [ ] ++ [ zstd ];
        });

    nativeBuildInputs = [
      ninja
      gnChromium
      bashInteractive # needed for compgen in buildPhase -> process_template
      pkg-config
      python3WithPackages
      perl
      which
      buildPackages.rustc.llvmPackages.bintools
      bison
      gperf
    ]
    ++ lib.optionals (!isElectron) [
      nodejs
      npmHooks.npmConfigHook
    ];

    depsBuildBuild = [
      buildPlatformLlvmStdenv
      buildPlatformLlvmStdenv.cc
      pkg-config
      libuuid
    ]
    # When cross-compiling, chromium builds a huge proportion of its
    # components for both the `buildPlatform` (which it calls
    # `host`) as well as for the `hostPlatform` -- easily more than
    # half of the dependencies are needed here.  To avoid having to
    # maintain a separate list of buildPlatform-dependencies, we
    # simply throw in the kitchen sink.
    # ** Because of overrides, we have to copy the list as it otherwise mess with splicing **
    ++ lib.optionals needsLibpng [
      (buildPackages.libpng.override { apngSupport = false; }) # https://bugs.chromium.org/p/chromium/issues/detail?id=752403
    ]
    ++ [
      (buildPackages.libopus.override { withCustomModes = true; })
      bzip2
      flac
      speex
      libevent
      expat
      libjpeg
      snappy
      libcap
      minizip
      libwebp
      libusb1
      re2
      ffmpeg
      libxslt
      libxml2
      nasm
      nspr
      nss
      util-linux
      alsa-lib
      libkrb5
      glib
      gtk3
      dbus-glib
      libXScrnSaver
      libXcursor
      libXtst
      libxshmfence
      libGLU
      libGL
      libgbm
      pciutils
      protobuf
      speechd-minimal
      libXdamage
      at-spi2-core
      pipewire
      libva
      libdrm
      wayland
      libxkbcommon
      curl
      libepoxy
      libffi
      libevdev
    ]
    ++ lib.optional systemdSupport systemdLibs
    ++ lib.optionals cupsSupport [
      libgcrypt
      cups
    ]
    ++ lib.optional pulseSupport libpulseaudio;

    buildInputs = [
    ]
    ++ lib.optionals needsLibpng [
      (libpng.override { apngSupport = false; }) # https://bugs.chromium.org/p/chromium/issues/detail?id=752403
    ]
    ++ [
      (libopus.override { withCustomModes = true; })
      bzip2
      flac
      speex
      libevent
      expat
      libjpeg
      snappy
      libcap
      minizip
      libwebp
      libusb1
      re2
      ffmpeg
      libxslt
      libxml2
      nasm
      nspr
      nss
      util-linux
      alsa-lib
      libkrb5
      glib
      gtk3
      dbus-glib
      libXScrnSaver
      libXcursor
      libXtst
      libxshmfence
      libGLU
      libGL
      dri-pkgconfig-stub
      libgbm
      pciutils
      protobuf
      speechd-minimal
      libXdamage
      at-spi2-core
      pipewire
      libva
      libdrm
      wayland
      libxkbcommon
      curl
      libepoxy
      libffi
      libevdev
    ]
    ++ lib.optional systemdSupport systemdLibs
    ++ lib.optionals cupsSupport [
      libgcrypt
      cups
    ]
    ++ lib.optional pulseSupport libpulseaudio;

    patches = [
      ./patches/cross-compile.patch
      # Optional patch to use SOURCE_DATE_EPOCH in compute_build_timestamp.py (should be upstreamed):
      ./patches/no-build-timestamps.patch
    ]
    ++ lib.optionals (packageName == "chromium") [
      # This patch is limited to chromium and ungoogled-chromium because electron-source sets
      # enable_widevine to false.
      #
      # The patch disables the automatic Widevine download (component) that happens at runtime
      # completely (~/.config/chromium/WidevineCdm/). This would happen if chromium encounters DRM
      # protected content or when manually opening chrome://components.
      #
      # It also prevents previously downloaded Widevine blobs in that location from being loaded and
      # used at all, while still allowing the use of our -wv wrapper. This is because those old
      # versions are out of out our control and may be vulnerable, given we literally disable their
      # auto updater.
      #
      # bundle_widevine_cdm is available as gn flag, but we cannot use it, as it expects a bunch of
      # files Widevine files at configure/compile phase that we don't have. Changing the value of the
      # BUNDLE_WIDEVINE_CDM build flag does work in the way we want though.
      # We also need enable_widevine_cdm_component to be false. Unfortunately it isn't exposed as gn
      # flag (declare_args) so we simply hardcode it to false.
      ./patches/widevine-disable-auto-download-allow-bundle.patch
    ]
    ++ [
      # Required to fix the build with a more recent wayland-protocols version
      # (we currently package 1.26 in Nixpkgs while Chromium bundles 1.21):
      # Source: https://bugs.chromium.org/p/angleproject/issues/detail?id=7582#c1
      ./patches/angle-wayland-include-protocol.patch
      # Chromium reads initial_preferences from its own executable directory
      # This patch modifies it to read /etc/chromium/initial_preferences
      ./patches/chromium-initial-prefs.patch
    ]
    ++ lib.optionals (!chromiumVersionAtLeast "142") [
      # https://github.com/chromium/chromium/commit/02b6456643700771597c00741937e22068b0f956
      # https://github.com/chromium/chromium/commit/69736ffe943ff996d4a88d15eb30103a8c854e29
      # Rebased variant of patch to build M126+ with LLVM 17.
      # staging-next will bump LLVM to 18, so we will be able to drop this soon.
      # Started failing to apply with M142, but this is no longer needed anyway.
      ./patches/chromium-126-llvm-17.patch
    ]
    ++ lib.optionals (!chromiumVersionAtLeast "140") [
      # Partial revert of https://github.com/chromium/chromium/commit/3687976b0c6d36cf4157419a24a39f6770098d61
      # allowing us to use our rustc and our clang.
      ./patches/chromium-129-rust.patch
    ]
    ++ lib.optionals (versionRange "140" "141") [
      # Rebased variant of the patch above due to
      # https://chromium-review.googlesource.com/c/chromium/src/+/6665907
      ./patches/chromium-140-rust.patch
    ]
    ++ lib.optionals (chromiumVersionAtLeast "141") [
      # Rebased variant of the patch above due to
      # https://chromium-review.googlesource.com/c/chromium/src/+/6897026
      ./patches/chromium-141-rust.patch
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      # Reverts decommit pooled pages which causes random crashes of tabs on systems
      # with page sizes different than 4k. It 'supports' runtime page sizes, but has
      # a hardcode for aarch64 systems.
      # https://issues.chromium.org/issues/378017037
      (fetchpatch {
        name = "reverted-v8-decommit-pooled-paged-by-default.patch";
        # https://chromium-review.googlesource.com/c/v8/v8/+/5864909
        url = "https://chromium.googlesource.com/v8/v8/+/1ab1a14ad97394d384d8dc6de51bb229625e66d6^!?format=TEXT";
        decode = "base64 -d";
        stripLen = 1;
        extraPrefix = "v8/";
        revert = true;
        hash = "sha256-PuinMLhJ2W4KPXI5K0ujw85ENTB1wG7Hv785SZ55xnY=";
      })
    ]
    ++ [
      # Modify the nodejs version check added in https://chromium-review.googlesource.com/c/chromium/src/+/6334038
      # to look for the minimal version, not the exact version (major.minor.patch). The linked CL makes a case for
      # preventing compilations of chromium with versions below their intended version, not about running the very
      # exact version or even running a newer version.
      ./patches/chromium-136-nodejs-assert-minimal-version-instead-of-exact-match.patch
    ]
    ++ lib.optionals (chromiumVersionAtLeast "138") [
      (fetchpatch {
        # Unbreak building with Rust 1.89+ which introduced
        # a new mismatched_lifetime_syntaxes lint.
        # https://issues.chromium.org/issues/424424323
        name = "chromium-138-rust-1.86-mismatched_lifetime_syntaxes.patch";
        # https://chromium-review.googlesource.com/c/chromium/src/+/6658267
        url = "https://chromium.googlesource.com/chromium/src/+/94a87ff38c51fd1a71980a5051d3553978391608^!?format=TEXT";
        decode = "base64 -d";
        includes = [ "build/rust/cargo_crate.gni" ];
        hash = "sha256-xf1Jq5v3InXkiVH0uT7+h1HPwZse5MDcHKuJNjSLR6k=";
      })
    ]
    ++ lib.optionals (!chromiumVersionAtLeast "138") [
      # Rebased variant of the patch above for
      # electron 35 (M134) and 36 (M136)
      ./patches/chromium-134-rust-1.86-mismatched_lifetime_syntaxes.patch
    ]
    ++ lib.optionals (versionRange "141" "142") [
      (fetchpatch {
        # Fix "invalid application of 'sizeof' to an incomplete type 'blink::CSSStyleSheet'"
        # by reverting https://chromium-review.googlesource.com/c/chromium/src/+/6892157
        name = "chromium-141-Revert-Remove-unnecessary-include-in-tree_scope.h.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/0fc0e71aa1ca0419fae6d14255025543980d2cba^!?format=TEXT";
        decode = "base64 -d";
        revert = true;
        hash = "sha256-pnEus2NHpNWZ6ZSXLgdTn+it7oy1MPZPbD8SOAKLWbw=";
      })
    ]
    ++ lib.optionals (chromiumVersionAtLeast "142" && lib.versionOlder rustcVersion "1.90") [
      (fetchpatch {
        # Fix "ld.lld: error: undefined symbol: __rustc::__rust_alloc_error_handler_should_panic'"
        # with Rust < 1.90 by reverting https://chromium-review.googlesource.com/c/chromium/src/+/6935385
        name = "chromium-142-Revert-rust-Remove-the-old-__rust_alloc_error_handler_should_panic-symbol.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/e33287758f2234d6aabfc5d4e011c4e81e3a47cf^!?format=TEXT";
        decode = "base64 -d";
        revert = true;
        hash = "sha256-0vRDz7wwGCsqm38fVvkLLzOOtEtd8CnqyjDLgGofh/o=";
      })
    ]
    ++ lib.optionals (versionRange "142" "143") [
      (fetchpatch {
        # Fix https://issues.chromium.org/issues/450752866 by backporting
        # https://chromium-review.googlesource.com/c/chromium/src/+/7030724 from M143
        name = "chromium-142-Backport-Add-missing-include-for-FormFieldData-type-completeness.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/069d424e41f42c6f4a4551334eafc7cfaed6e880^!?format=TEXT";
        decode = "base64 -d";
        hash = "sha256-0ueOCHYheSFHRFzEat3TDhnU3Avf0TcNBBBpTkz+saw=";
      })
    ]
    ++ lib.optionals (chromiumVersionAtLeast "142" && lib.versionOlder rustcVersion "1.91") [
      # Fix the following error when compiling CrabbyAvif with Rust < 1.91 due to
      # https://github.com/rust-lang/rust/pull/142681 by reverting
      # https://github.com/webmproject/CrabbyAvif/pull/663 and
      # https://github.com/webmproject/CrabbyAvif/pull/654 and
      # https://chromium-review.googlesource.com/c/chromium/src/+/6960510
      #
      #  error: cannot find attribute `sanitize` in this scope
      #    --> ../../third_party/crabbyavif/src/src/capi/io.rs:210:41
      #      |
      #  210 |     #[cfg_attr(feature = "disable_cfi", sanitize(cfi = "off"))]
      #      |                                         ^^^^^^^^
      #
      ./patches/chromium-142-crabbyavif-rust-no_sanitize.patch
      (fetchpatch {
        name = "chromium-142-crabbyavif-Revert-Enable-disable_cfi-feature.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/9415f40bc6f853547f791e633be638c71368ce56^!?format=TEXT";
        decode = "base64 -d";
        revert = true;
        hash = "sha256-bYcJqPMbE7hMvhZVnzqHok1crUAdqrzqxr+4IHNzAtg=";
      })
    ];

    postPatch =
      # TODO: reuse mkGnFlags for this
      # TODO: reflow
      lib.optionalString (!isElectron) ''
        cp ${./files/gclient_args.gni} build/config/gclient_args.gni
        chmod u+w build/config/gclient_args.gni
        echo 'checkout_mutter = false' >> build/config/gclient_args.gni
        echo 'checkout_glic_e2e_tests = false' >> build/config/gclient_args.gni
        echo 'checkout_clusterfuzz_data = false' >> build/config/gclient_args.gni
      ''
      + lib.optionalString (!isElectron) ''

        echo 'LASTCHANGE=${upstream-info.DEPS."src".rev}-refs/tags/${version}@{#0}' > build/util/LASTCHANGE
        echo "$SOURCE_DATE_EPOCH" > build/util/LASTCHANGE.committime

        cat << EOF > gpu/config/gpu_lists_version.h
        /* Generated by lastchange.py, do not edit.*/
        #ifndef GPU_CONFIG_GPU_LISTS_VERSION_H_
        #define GPU_CONFIG_GPU_LISTS_VERSION_H_
        #define GPU_LISTS_VERSION "${upstream-info.DEPS."src".rev}"
        #endif  // GPU_CONFIG_GPU_LISTS_VERSION_H_
        EOF

        cat << EOF > skia/ext/skia_commit_hash.h
        /* Generated by lastchange.py, do not edit.*/
        #ifndef SKIA_EXT_SKIA_COMMIT_HASH_H_
        #define SKIA_EXT_SKIA_COMMIT_HASH_H_
        #define SKIA_COMMIT_HASH "${upstream-info.DEPS."src/third_party/skia".rev}${
          lib.optionalString (!chromiumVersionAtLeast "142") "-"
        }"
        #endif  // SKIA_EXT_SKIA_COMMIT_HASH_H_
        EOF

        echo -n '${upstream-info.DEPS."src/third_party/dawn".rev}' > gpu/webgpu/DAWN_VERSION

        mkdir -p third_party/jdk/current/bin
      ''
      + lib.optionalString (!isElectron && chromiumVersionAtLeast "142") ''
        cat << EOF > gpu/webgpu/dawn_commit_hash.h
        /* Generated by lastchange.py, do not edit.*/
        #ifndef GPU_WEBGPU_DAWN_COMMIT_HASH_H_
        #define GPU_WEBGPU_DAWN_COMMIT_HASH_H_
        #define DAWN_COMMIT_HASH "${upstream-info.DEPS."src/third_party/dawn".rev}"
        #endif  // GPU_WEBGPU_DAWN_COMMIT_HASH_H_
        EOF
      ''
      + ''
        # Workaround/fix for https://bugs.chromium.org/p/chromium/issues/detail?id=1313361:
        substituteInPlace BUILD.gn \
          --replace '"//infra/orchestrator:orchestrator_all",' ""
        # Disable build flags that require LLVM 15:
        substituteInPlace build/config/compiler/BUILD.gn \
          --replace '"-Xclang",' "" \
          --replace '"-no-opaque-pointers",' ""
        # remove unused third-party
        for lib in ${toString gnSystemLibraries}; do
          if [ -d "third_party/$lib" ]; then
            find "third_party/$lib" -type f \
              \! -path "third_party/$lib/chromium/*" \
              \! -path "third_party/$lib/google/*" \
              \! -path "third_party/harfbuzz-ng/utils/hb_scoped.h" \
              \! -regex '.*\.\(gn\|gni\|isolate\)' \
              -delete
          fi
        done

        if [[ -e native_client/SConstruct ]]; then
          # Required for patchShebangs (unsupported interpreter directive, basename: invalid option -- '*', etc.):
          substituteInPlace native_client/SConstruct --replace "#! -*- python -*-" ""
        fi
        if [ -e third_party/harfbuzz-ng/src/src/update-unicode-tables.make ]; then
          substituteInPlace third_party/harfbuzz-ng/src/src/update-unicode-tables.make \
            --replace "/usr/bin/env -S make -f" "/usr/bin/make -f"
        fi
        if [ -e third_party/webgpu-cts/src/tools/run_deno ]; then
          chmod -x third_party/webgpu-cts/src/tools/run_deno
        fi
        if [ -e third_party/dawn/third_party/webgpu-cts/tools/run_deno ]; then
          chmod -x third_party/dawn/third_party/webgpu-cts/tools/run_deno
        fi

        # We want to be able to specify where the sandbox is via CHROME_DEVEL_SANDBOX
        substituteInPlace sandbox/linux/suid/client/setuid_sandbox_host.cc \
          --replace \
            'return sandbox_binary;' \
            'return base::FilePath(GetDevelSandboxPath());'

        substituteInPlace services/audio/audio_sandbox_hook_linux.cc \
          --replace \
            '/usr/share/alsa/' \
            '${alsa-lib}/share/alsa/' \
          --replace \
            '/usr/lib/x86_64-linux-gnu/gconv/' \
            '${glibc}/lib/gconv/' \
          --replace \
            '/usr/share/locale/' \
            '${glibc}/share/locale/'

      ''
      + ''
        # Allow to put extensions into the system-path.
        sed -i -e 's,/usr,/run/current-system/sw,' chrome/common/chrome_paths.cc

        # Add final newlines to scripts that do not end with one.
        # This is a temporary workaround until https://github.com/NixOS/nixpkgs/pull/255463 (or similar) has been merged,
        # as patchShebangs hard-crashes when it encounters files that contain only a shebang and do not end with a final
        # newline.
        find . -type f -perm -0100 -exec sed -i -e '$a\' {} +

        patchShebangs .
      ''
      + lib.optionalString ungoogled ''
        # Prune binaries (ungoogled only) *before* linking our own binaries:
        ${ungoogler}/utils/prune_binaries.py . ${ungoogler}/pruning.list || echo "some errors"
      ''
      + ''
        # Link to our own Node.js and Java (required during the build):
        mkdir -p third_party/node/linux/node-linux-x64/bin${lib.optionalString ungoogled " third_party/jdk/current/bin/"}
        ln -sf "${pkgsBuildHost.nodejs}/bin/node" third_party/node/linux/node-linux-x64/bin/node
        ln -s "${pkgsBuildHost.jdk17_headless}/bin/java" third_party/jdk/current/bin/

        # Allow building against system libraries in official builds
        sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' tools/generate_shim_headers/generate_shim_headers.py

      ''
      +
        lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform && stdenv.hostPlatform.isAarch64)
          ''
            substituteInPlace build/toolchain/linux/BUILD.gn \
              --replace 'toolprefix = "aarch64-linux-gnu-"' 'toolprefix = ""'
          ''
      + lib.optionalString ungoogled ''
        ${ungoogler}/utils/patches.py . ${ungoogler}/patches
        ${ungoogler}/utils/domain_substitution.py apply -r ${ungoogler}/domain_regex.list -f ${ungoogler}/domain_substitution.list -c ./ungoogled-domsubcache.tar.gz .
      '';

    llvmCcAndBintools = symlinkJoin {
      name = "llvmCcAndBintools";
      paths = [
        buildPackages.rustc.llvmPackages.llvm
        buildPackages.rustc.llvmPackages.stdenv.cc
      ];
    };

    gnFlags = mkGnFlags (
      {
        # Main build and toolchain settings:
        # Create an official and optimized release build (only official builds
        # should be distributed to users, as non-official builds are intended for
        # development and may not be configured appropriately for production,
        # e.g. unsafe developer builds have developer-friendly features that may
        # weaken or disable security measures like sandboxing or ASLR):
        is_official_build = true;
        disable_fieldtrial_testing_config = true;

        # note: chromium calls buildPlatform "host" and calls hostPlatform "target"
        host_cpu = chromiumRosettaStone.cpu stdenv.buildPlatform;
        host_os = chromiumRosettaStone.os stdenv.buildPlatform;
        target_cpu = chromiumRosettaStone.cpu stdenv.hostPlatform;
        v8_target_cpu = chromiumRosettaStone.cpu stdenv.hostPlatform;
        target_os = chromiumRosettaStone.os stdenv.hostPlatform;

        # Build Chromium using the system toolchain (for Linux distributions):
        #
        # What you would expect to be called "target_toolchain" is
        # actually called either "default_toolchain" or "custom_toolchain",
        # depending on which part of the codebase you are in; see:
        # https://github.com/chromium/chromium/blob/d36462cc9279464395aea5e65d0893d76444a296/build/config/BUILDCONFIG.gn#L17-L44
        custom_toolchain = "//build/toolchain/linux/unbundle:default";
        host_toolchain = "//build/toolchain/linux/unbundle:default";
        # We only build those specific toolchains when we cross-compile, as native non-cross-compilations would otherwise
        # end up building much more things than they need to (roughly double the build steps and time/compute):
      }
      // lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) {
        host_toolchain = "//build/toolchain/linux/unbundle:host";
        v8_snapshot_toolchain = "//build/toolchain/linux/unbundle:host";
      }
      // {
        host_pkg_config = "${pkgsBuildBuild.pkg-config}/bin/pkg-config";
        pkg_config = "${pkgsBuildHost.pkg-config}/bin/${stdenv.cc.targetPrefix}pkg-config";

        # Don't build against a sysroot image downloaded from Cloud Storage:
        use_sysroot = false;
        # Because we use a different toolchain / compiler version:
        treat_warnings_as_errors = false;
        # We aren't compiling with Chrome's Clang (would enable Chrome-specific
        # plugins for enforcing coding guidelines, etc.):
        clang_use_chrome_plugins = false;
        # Disable symbols (they would negatively affect the performance of the
        # build since the symbols are large and dealing with them is slow):
        symbol_level = 0;
        blink_symbol_level = 0;

        # Google API key, see: https://www.chromium.org/developers/how-tos/api-keys
        # Note: The API key is for NixOS/nixpkgs use ONLY.
        # For your own distribution, please get your own set of keys.
        google_api_key = "AIzaSyDGi15Zwl11UNe6Y-5XW_upsfyw31qwZPI";

        # Optional features:
        use_gio = true;
        use_cups = cupsSupport;
      }
      // lib.optionalAttrs (!chromiumVersionAtLeast "139") {
        # Feature overrides:
        # Native Client support was deprecated in 2020 and support will end in June 2021:
        enable_nacl = false;
      }
      // lib.optionalAttrs (packageName == "chromium") {
        # Enabling the Widevine here doesn't affect whether we can redistribute the chromium package.
        # Widevine in this drv is a bit more complex than just that. See Widevine patch somewhere above.
        enable_widevine = true;
      }
      // {
        # Provides the enable-webrtc-pipewire-capturer flag to support Wayland screen capture:
        rtc_use_pipewire = true;
        # Disable PGO because the profile data requires a newer compiler version (LLVM 14 isn't sufficient):
        chrome_pgo_phase = 0;
        clang_base_path = "${llvmCcAndBintools}";
      }
      // lib.optionalAttrs (chromiumVersionAtLeast "141") {
        # TODO: remove opt-out of https://chromium.googlesource.com/chromium/src/+/main/docs/modules.md
        use_clang_modules = false;
      }
      // {
        use_qt5 = false;
        use_qt6 = false;

        # LLVM < v21 does not support --warning-suppression-mappings yet:
        clang_warning_suppression_file = "";

        # To fix the build as we don't provide libffi_pic.a
        # (ld.lld: error: unable to find library -l:libffi_pic.a):
        use_system_libffi = true;
        # Use nixpkgs Rust compiler instead of the one shipped by Chromium.
        rust_sysroot_absolute = "${buildPackages.rustc}";
        rust_bindgen_root = "${buildPackages.rust-bindgen}";
        enable_rust = true;
        # While we technically don't need the cache-invalidation rustc_version provides, rustc_version
        # is still used in some scripts (e.g. build/rust/std/find_std_rlibs.py).
        rustc_version = rustcVersion;
      }
      // lib.optionalAttrs (!(stdenv.buildPlatform.canExecute stdenv.hostPlatform)) {
        # https://www.mail-archive.com/v8-users@googlegroups.com/msg14528.html
        arm_control_flow_integrity = "none";
      }
      // lib.optionalAttrs proprietaryCodecs {
        # enable support for the H.264 codec
        proprietary_codecs = true;
        enable_hangout_services_extension = true;
        ffmpeg_branding = "Chrome";
      }
      // lib.optionalAttrs stdenv.hostPlatform.isAarch64 {
        # Enable v4l2 video decoder for hardware acceleratation on aarch64:
        use_vaapi = false;
        use_v4l2_codec = true;
      }
      // lib.optionalAttrs pulseSupport {
        use_pulseaudio = true;
        link_pulseaudio = true;
      }
      // lib.optionalAttrs ungoogled (lib.importTOML ./ungoogled-flags.toml)
      // (extraAttrs.gnFlags or { })
    );

    preConfigure = lib.optionalString (!isElectron) ''
      (
        cd third_party/node
        grep patch update_npm_deps | sh
      )
    '';

    configurePhase = ''
      runHook preConfigure

      # This is to ensure expansion of $out.
      libExecPath="${libExecPath}"
      ${python3.pythonOnBuildForHost}/bin/python3 build/linux/unbundle/replace_gn_files.py --system-libraries ${toString gnSystemLibraries}
      gn gen --args=${lib.escapeShellArg gnFlags} out/Release | tee gn-gen-outputs.txt

      # Fail if `gn gen` contains a WARNING.
      grep -o WARNING gn-gen-outputs.txt && echo "Found gn WARNING, exiting nix build" && exit 1

      runHook postConfigure
    '';

    # Chromium expects nightly/bleeding edge rustc features to be available.
    # Our rustc in nixpkgs follows stable, but since bootstrapping rustc requires
    # nightly features too, we can (ab-)use RUSTC_BOOTSTRAP here as well to
    # enable those features in our stable builds.
    env.RUSTC_BOOTSTRAP = 1;
    # Mute some warnings that are enabled by default. This is useful because
    # our Clang is always older than Chromium's and the build logs have a size
    # of approx. 25 MB without this option (and this saves e.g. 66 %).
    env.NIX_CFLAGS_COMPILE = "-Wno-unknown-warning-option -Wno-unused-command-line-argument -Wno-shadow";
    env.BUILD_CC = "$CC_FOR_BUILD";
    env.BUILD_CXX = "$CXX_FOR_BUILD";
    env.BUILD_AR = "$AR_FOR_BUILD";
    env.BUILD_NM = "$NM_FOR_BUILD";
    env.BUILD_READELF = "$READELF_FOR_BUILD";

    buildPhase =
      let
        buildCommand = target: ''
          TERM=dumb ninja -C "${buildPath}" -j$NIX_BUILD_CORES "${target}"
          bash -s << EOL
          (
            source chrome/installer/linux/common/installer.include
            PACKAGE=$packageName
            MENUNAME="Chromium"
            process_template chrome/app/resources/manpage.1.in "${buildPath}/chrome.1"
          )
          EOL
        '';
        targets = extraAttrs.buildTargets or [ ];
        commands = map buildCommand targets;
      in
      ''
        runHook preBuild
        ${lib.concatStringsSep "\n" commands}
        runHook postBuild
      '';

    postFixup = ''
      # Make sure that libGLESv2 and libvulkan are found by dlopen in both chromium binary and ANGLE libGLESv2.so.
      # libpci (from pciutils) is needed by dlopen in angle/src/gpu_info_util/SystemInfo_libpci.cpp
      for chromiumBinary in "$libExecPath/$packageName" "$libExecPath/libGLESv2.so"; do
        patchelf --set-rpath "${
          lib.makeLibraryPath [
            libGL
            vulkan-loader
            pciutils
          ]
        }:$(patchelf --print-rpath "$chromiumBinary")" "$chromiumBinary"
      done

      # replace bundled vulkan-loader
      rm "$libExecPath/libvulkan.so.1"
      ln -s -t "$libExecPath" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"
    '';

    passthru = {
      updateScript = ./update.mjs;
    }
    // lib.optionalAttrs (!isElectron) {
      inherit chromiumDeps npmDeps;
    };
  };

in
# Remove some extraAttrs we supplied to the base attributes already.
stdenv.mkDerivation (
  base
  // removeAttrs extraAttrs [
    "name"
    "gnFlags"
    "buildTargets"
  ]
  // {
    passthru = base.passthru // (extraAttrs.passthru or { });
  }
)
