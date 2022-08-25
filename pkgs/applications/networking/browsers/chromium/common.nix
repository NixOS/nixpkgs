{ stdenv, lib, fetchurl, fetchpatch
# Channel data:
, channel, upstream-info
# Helper functions:
, chromiumVersionAtLeast, versionRange

# Native build inputs:
, ninja, pkg-config
, python3, perl
, which
, llvmPackages
# postPatch:
, pkgsBuildHost
# configurePhase:
, gnChromium

# Build inputs:
, libpng
, bzip2, flac, speex, libopus
, libevent, expat, libjpeg, snappy
, libcap
, xdg-utils, minizip, libwebp
, libusb1, re2
, ffmpeg, libxslt, libxml2
, nasm
, nspr, nss
, util-linux, alsa-lib
, bison, gperf, libkrb5
, glib, gtk3, dbus-glib
, libXScrnSaver, libXcursor, libXtst, libxshmfence, libGLU, libGL
, mesa
, pciutils, protobuf, speechd, libXdamage, at-spi2-core
, pipewire
, libva
, libdrm, wayland, libxkbcommon # Ozone
, curl
, libepoxy
# postPatch:
, glibc # gconv + locale

# Package customization:
, cupsSupport ? true, cups ? null
, proprietaryCodecs ? true
, pulseSupport ? false, libpulseaudio ? null
, ungoogled ? false, ungoogled-chromium
# Optional dependencies:
, libgcrypt ? null # cupsSupport
, systemdSupport ? stdenv.isLinux
, systemd
}:

buildFun:

with lib;

let
  python3WithPackages = python3.withPackages(ps: with ps; [
    ply jinja2 setuptools
  ]);
  clangFormatPython3 = fetchurl {
    url = "https://chromium.googlesource.com/chromium/tools/build/+/e77882e0dde52c2ccf33c5570929b75b4a2a2522/recipes/recipe_modules/chromium/resources/clang-format?format=TEXT";
    sha256 = "0ic3hn65dimgfhakli1cyf9j3cxcqsf1qib706ihfhmlzxf7256l";
  };

  # The additional attributes for creating derivations based on the chromium
  # source tree.
  extraAttrs = buildFun base;

  githubPatch = { commit, sha256, revert ? false }: fetchpatch {
    url = "https://github.com/chromium/chromium/commit/${commit}.patch";
    inherit sha256 revert;
  };

  mkGnFlags =
    let
      # Serialize Nix types into GN types according to this document:
      # https://source.chromium.org/gn/gn/+/master:docs/language.md
      mkGnString = value: "\"${escape ["\"" "$" "\\"] value}\"";
      sanitize = value:
        if value == true then "true"
        else if value == false then "false"
        else if isList value then "[${concatMapStringsSep ", " sanitize value}]"
        else if isInt value then toString value
        else if isString value then mkGnString value
        else throw "Unsupported type for GN value `${value}'.";
      toFlag = key: value: "${key}=${sanitize value}";
    in attrs: concatStringsSep " " (attrValues (mapAttrs toFlag attrs));

  # https://source.chromium.org/chromium/chromium/src/+/master:build/linux/unbundle/replace_gn_files.py
  gnSystemLibraries = [
    # TODO:
    # "ffmpeg"
    # "snappy"
    "flac"
    "libjpeg"
    "libpng"
    "libwebp"
    "libxslt"
    # "opus"
  ];

  opusWithCustomModes = libopus.override {
    withCustomModes = true;
  };

  # build paths and release info
  packageName = extraAttrs.packageName or extraAttrs.name;
  buildType = "Release";
  buildPath = "out/${buildType}";
  libExecPath = "$out/libexec/${packageName}";

  ungoogler = ungoogled-chromium {
    inherit (upstream-info.deps.ungoogled-patches) rev sha256;
  };

  base = rec {
    pname = "${packageName}-unwrapped";
    inherit (upstream-info) version;
    inherit packageName buildType buildPath;

    src = fetchurl {
      url = "https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${version}.tar.xz";
      inherit (upstream-info) sha256;
    };

    nativeBuildInputs = [
      ninja pkg-config
      python3WithPackages perl
      which
      llvmPackages.bintools
    ];

    buildInputs = [
      (libpng.override { apngSupport = false; }) # https://bugs.chromium.org/p/chromium/issues/detail?id=752403
      bzip2 flac speex opusWithCustomModes
      libevent expat libjpeg snappy
      libcap
      xdg-utils minizip libwebp
      libusb1 re2
      ffmpeg libxslt libxml2
      nasm
      nspr nss
      util-linux alsa-lib
      bison gperf libkrb5
      glib gtk3 dbus-glib
      libXScrnSaver libXcursor libXtst libxshmfence libGLU libGL
      mesa # required for libgbm
      pciutils protobuf speechd libXdamage at-spi2-core
      pipewire
      libva
      libdrm wayland mesa.drivers libxkbcommon
      curl
      libepoxy
    ] ++ optional systemdSupport systemd
      ++ optionals cupsSupport [ libgcrypt cups ]
      ++ optional pulseSupport libpulseaudio;

    patches = [
      # Optional patch to use SOURCE_DATE_EPOCH in compute_build_timestamp.py (should be upstreamed):
      ./patches/no-build-timestamps.patch
      # For bundling Widevine (DRM), might be replaceable via bundle_widevine_cdm=true in gnFlags:
      ./patches/widevine-79.patch
    ];

    postPatch = ''
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

      # Required for patchShebangs (unsupported interpreter directive, basename: invalid option -- '*', etc.):
      substituteInPlace native_client/SConstruct --replace "#! -*- python -*-" ""
      if [ -e third_party/harfbuzz-ng/src/src/update-unicode-tables.make ]; then
        substituteInPlace third_party/harfbuzz-ng/src/src/update-unicode-tables.make \
          --replace "/usr/bin/env -S make -f" "/usr/bin/make -f"
      fi
      chmod -x third_party/webgpu-cts/src/tools/run_deno
      chmod -x third_party/dawn/third_party/webgpu-cts/tools/run_deno

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

      sed -i -e 's@"\(#!\)\?.*xdg-@"\1${xdg-utils}/bin/xdg-@' \
        chrome/browser/shell_integration_linux.cc

    '' + lib.optionalString systemdSupport ''
      sed -i -e '/lib_loader.*Load/s!"\(libudev\.so\)!"${lib.getLib systemd}/lib/\1!' \
        device/udev_linux/udev?_loader.cc
    '' + ''
      sed -i -e '/libpci_loader.*Load/s!"\(libpci\.so\)!"${pciutils}/lib/\1!' \
        gpu/config/gpu_info_collector_linux.cc

      # Allow to put extensions into the system-path.
      sed -i -e 's,/usr,/run/current-system/sw,' chrome/common/chrome_paths.cc

      # We need the fix for https://bugs.chromium.org/p/chromium/issues/detail?id=1254408:
      base64 --decode ${clangFormatPython3} > buildtools/linux64/clang-format

      patchShebangs .
      # Link to our own Node.js and Java (required during the build):
      mkdir -p third_party/node/linux/node-linux-x64/bin
      ln -s "${pkgsBuildHost.nodejs}/bin/node" third_party/node/linux/node-linux-x64/bin/node
      ln -s "${pkgsBuildHost.jre8_headless}/bin/java" third_party/jdk/current/bin/

      # Allow building against system libraries in official builds
      sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' tools/generate_shim_headers/generate_shim_headers.py

    '' + optionalString stdenv.isAarch64 ''
      substituteInPlace build/toolchain/linux/BUILD.gn \
        --replace 'toolprefix = "aarch64-linux-gnu-"' 'toolprefix = ""'
    '' + optionalString ungoogled ''
      ${ungoogler}/utils/prune_binaries.py . ${ungoogler}/pruning.list || echo "some errors"
      ${ungoogler}/utils/patches.py . ${ungoogler}/patches
      ${ungoogler}/utils/domain_substitution.py apply -r ${ungoogler}/domain_regex.list -f ${ungoogler}/domain_substitution.list -c ./ungoogled-domsubcache.tar.gz .
    '';

    gnFlags = mkGnFlags ({
      # Main build and toolchain settings:
      # Create an official and optimized release build (only official builds
      # should be distributed to users, as non-official builds are intended for
      # development and may not be configured appropriately for production,
      # e.g. unsafe developer builds have developer-friendly features that may
      # weaken or disable security measures like sandboxing or ASLR):
      is_official_build = true;
      disable_fieldtrial_testing_config = true;
      # Build Chromium using the system toolchain (for Linux distributions):
      custom_toolchain = "//build/toolchain/linux/unbundle:default";
      host_toolchain = "//build/toolchain/linux/unbundle:default";
      # Don't build against a sysroot image downloaded from Cloud Storage:
      use_sysroot = false;
      # The default value is hardcoded instead of using pkg-config:
      system_wayland_scanner_path = "${wayland}/bin/wayland-scanner";
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
      use_gnome_keyring = false; # Superseded by libsecret
      use_cups = cupsSupport;

      # Feature overrides:
      # Native Client support was deprecated in 2020 and support will end in June 2021:
      enable_nacl = false;
      # Enabling the Widevine component here doesn't affect whether we can
      # redistribute the chromium package; the Widevine component is either
      # added later in the wrapped -wv build or downloaded from Google:
      enable_widevine = true;
      # Provides the enable-webrtc-pipewire-capturer flag to support Wayland screen capture:
      rtc_use_pipewire = true;
      # Disable PGO because the profile data requires a newer compiler version (LLVM 14 isn't sufficient):
      chrome_pgo_phase = 0;
    } // optionalAttrs (chromiumVersionAtLeast "105") {
      # https://bugs.chromium.org/p/chromium/issues/detail?id=1334390:
      use_system_libwayland = false;
      use_system_wayland_scanner = false;
    } // optionalAttrs proprietaryCodecs {
      # enable support for the H.264 codec
      proprietary_codecs = true;
      enable_hangout_services_extension = true;
      ffmpeg_branding = "Chrome";
    } // optionalAttrs pulseSupport {
      use_pulseaudio = true;
      link_pulseaudio = true;
    } // optionalAttrs ungoogled (importTOML ./ungoogled-flags.toml)
    // (extraAttrs.gnFlags or {}));

    configurePhase = ''
      runHook preConfigure

      # This is to ensure expansion of $out.
      libExecPath="${libExecPath}"
      ${python3}/bin/python3 build/linux/unbundle/replace_gn_files.py --system-libraries ${toString gnSystemLibraries}
      ${gnChromium}/bin/gn gen --args=${escapeShellArg gnFlags} out/Release | tee gn-gen-outputs.txt

      # Fail if `gn gen` contains a WARNING.
      grep -o WARNING gn-gen-outputs.txt && echo "Found gn WARNING, exiting nix build" && exit 1

      runHook postConfigure
    '';

    # Don't spam warnings about unknown warning options. This is useful because
    # our Clang is always older than Chromium's and the build logs have a size
    # of approx. 25 MB without this option (and this saves e.g. 66 %).
    NIX_CFLAGS_COMPILE = "-Wno-unknown-warning-option";

    buildPhase = let
      buildCommand = target: ''
        ninja -C "${buildPath}" -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES "${target}"
        (
          source chrome/installer/linux/common/installer.include
          PACKAGE=$packageName
          MENUNAME="Chromium"
          process_template chrome/app/resources/manpage.1.in "${buildPath}/chrome.1"
        )
      '';
      targets = extraAttrs.buildTargets or [];
      commands = map buildCommand targets;
    in concatStringsSep "\n" commands;

    postFixup = ''
      # Make sure that libGLESv2 is found by dlopen (if using EGL).
      chromiumBinary="$libExecPath/$packageName"
      origRpath="$(patchelf --print-rpath "$chromiumBinary")"
      patchelf --set-rpath "${libGL}/lib:$origRpath" "$chromiumBinary"
    '';

    passthru = {
      updateScript = ./update.py;
      chromiumDeps = {
        gn = gnChromium;
      };
    };
  };

# Remove some extraAttrs we supplied to the base attributes already.
in stdenv.mkDerivation (base // removeAttrs extraAttrs [
  "name" "gnFlags" "buildTargets"
] // { passthru = base.passthru // (extraAttrs.passthru or {}); })
