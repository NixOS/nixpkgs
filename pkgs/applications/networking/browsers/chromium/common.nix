{ stdenv, lib, fetchurl, fetchpatch
# Channel data:
, channel, upstream-info
# Helper functions:
, chromiumVersionAtLeast, versionRange

# Native build inputs:
, ninja, pkg-config
, python2, python3, perl
, gnutar, which
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
, nspr, nss, systemd
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
# postPatch:
, glibc # gconv + locale

# Package customization:
, gnomeSupport ? false, gnome2 ? null
, gnomeKeyringSupport ? false, libgnome-keyring3 ? null
, cupsSupport ? true, cups ? null
, proprietaryCodecs ? true
, pulseSupport ? false, libpulseaudio ? null
, ungoogled ? false, ungoogled-chromium
# Optional dependencies:
, libgcrypt ? null # gnomeSupport || cupsSupport
}:

buildFun:

with lib;

let
  python2WithPackages = python2.withPackages(ps: with ps; [
    ply jinja2 setuptools
  ]);
  python3WithPackages = python3.withPackages(ps: with ps; [
    ply jinja2 setuptools
  ]);

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
  gnSystemLibraries = lib.optionals (!chromiumVersionAtLeast "93") [
    "ffmpeg"
    "snappy"
  ] ++ [
    "flac"
    "libjpeg"
    "libpng"
    "libwebp"
    "libxslt"
    "opus"
    "zlib"
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
    name = "${packageName}-unwrapped-${version}";
    inherit (upstream-info) version;
    inherit packageName buildType buildPath;

    src = fetchurl {
      url = "https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${version}.tar.xz";
      inherit (upstream-info) sha256;
    };

    nativeBuildInputs = [
      ninja pkg-config
      python2WithPackages python3WithPackages perl
      gnutar which
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
      nspr nss systemd
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
    ] ++ optionals gnomeSupport [ gnome2.GConf libgcrypt ]
      ++ optional gnomeKeyringSupport libgnome-keyring3
      ++ optionals cupsSupport [ libgcrypt cups ]
      ++ optional pulseSupport libpulseaudio;

    patches = [
      # Optional patch to use SOURCE_DATE_EPOCH in compute_build_timestamp.py (should be upstreamed):
      ./patches/no-build-timestamps.patch
      # For bundling Widevine (DRM), might be replaceable via bundle_widevine_cdm=true in gnFlags:
      ./patches/widevine-79.patch
    ] ++ lib.optionals (versionRange "91" "94") [
      # Fix the build by adding a missing dependency (s. https://crbug.com/1197837):
      ./patches/fix-missing-atspi2-dependency.patch
      # Required as dependency for the next patch:
      (githubPatch {
        # Reland "Reland "Linux sandbox syscall broker: use struct kernel_stat""
        commit = "4b438323d68840453b5ef826c3997568e2e0e8c7";
        sha256 = "1lf6yilx2ffd3r0840ilihp4px35w7jvr19ll56bncqmz4r5fd82";
      })
      # To fix the text rendering, see #131074:
      (githubPatch {
        # Linux sandbox: fix fstatat() crash
        commit = "60d5e803ef2a4874d29799b638754152285e0ed9";
        sha256 = "0apmsqqlfxprmdmi3qzp3kr9jc52mcc4xzps206kwr8kzwv48b70";
      })
    ];

    postPatch = ''
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
      chmod -x third_party/webgpu-cts/src/tools/deno

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

      sed -i -e '/lib_loader.*Load/s!"\(libudev\.so\)!"${lib.getLib systemd}/lib/\1!' \
        device/udev_linux/udev?_loader.cc

      sed -i -e '/libpci_loader.*Load/s!"\(libpci\.so\)!"${pciutils}/lib/\1!' \
        gpu/config/gpu_info_collector_linux.cc

      # Allow to put extensions into the system-path.
      sed -i -e 's,/usr,/run/current-system/sw,' chrome/common/chrome_paths.cc

      patchShebangs .
      # Link to our own Node.js and Java (required during the build):
      mkdir -p third_party/node/linux/node-linux-x64/bin
      ln -s "${pkgsBuildHost.nodejs}/bin/node" third_party/node/linux/node-linux-x64/bin/node
      ln -s "${pkgsBuildHost.jre8}/bin/java" third_party/jdk/current/bin/

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
      use_gio = gnomeSupport;
      use_gnome_keyring = gnomeKeyringSupport;
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
    } // optionalAttrs (!chromiumVersionAtLeast "94") {
      fieldtrial_testing_like_official_build = true;
    } // optionalAttrs (chromiumVersionAtLeast "94") {
      disable_fieldtrial_testing_config = true;
    } // optionalAttrs proprietaryCodecs {
      # enable support for the H.264 codec
      proprietary_codecs = true;
      enable_hangout_services_extension = true;
      ffmpeg_branding = "Chrome";
    } // optionalAttrs pulseSupport {
      use_pulseaudio = true;
      link_pulseaudio = true;
    } // optionalAttrs ungoogled {
      chrome_pgo_phase = 0;
      enable_hangout_services_extension = false;
      enable_js_type_check = false;
      enable_mdns = false;
      enable_nacl_nonsfi = false;
      enable_one_click_signin = false;
      enable_reading_list = false;
      enable_remoting = false;
      enable_reporting = false;
      enable_service_discovery = false;
      exclude_unwind_tables = true;
      google_api_key = "";
      google_default_client_id = "";
      google_default_client_secret = "";
      safe_browsing_mode = 0;
      use_official_google_api_keys = false;
      use_unofficial_version_number = false;
    } // (extraAttrs.gnFlags or {}));

    configurePhase = ''
      runHook preConfigure

      # This is to ensure expansion of $out.
      libExecPath="${libExecPath}"
      ${python2}/bin/python2 build/linux/unbundle/replace_gn_files.py --system-libraries ${toString gnSystemLibraries}
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
