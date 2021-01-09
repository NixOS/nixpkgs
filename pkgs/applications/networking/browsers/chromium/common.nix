{ stdenv, lib, llvmPackages, gnChromium, ninja, which, nodejs, fetchpatch, fetchurl

# default dependencies
, gnutar, bzip2, flac, speex, libopus
, libevent, expat, libjpeg, snappy
, libpng, libcap
, xdg_utils, yasm, nasm, minizip, libwebp
, libusb1, pciutils, nss, re2

, python2Packages, perl, pkgconfig
, nspr, systemd, kerberos
, util-linux, alsaLib
, bison, gperf
, glib, gtk3, dbus-glib
, glibc
, libXScrnSaver, libXcursor, libXtst, libxshmfence, libGLU, libGL
, protobuf, speechd, libXdamage, cups
, ffmpeg, libxslt, libxml2, at-spi2-core
, jre8
, pipewire_0_2
, libva

# optional dependencies
, libgcrypt ? null # gnomeSupport || cupsSupport
, libdrm ? null, wayland ? null, mesa ? null, libxkbcommon ? null # useOzone

# package customization
, useOzone ? true
, gnomeSupport ? false, gnome ? null
, gnomeKeyringSupport ? false, libgnome-keyring3 ? null
, proprietaryCodecs ? true
, cupsSupport ? true
, pulseSupport ? false, libpulseaudio ? null
, ungoogled ? false, ungoogled-chromium

, channel
, upstream-info
}:

buildFun:

with stdenv.lib;

let
  jre = jre8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731

  # The additional attributes for creating derivations based on the chromium
  # source tree.
  extraAttrs = buildFun base;

  githubPatch = commit: sha256: fetchpatch {
    url = "https://github.com/chromium/chromium/commit/${commit}.patch";
    inherit sha256;
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
    "ffmpeg"
    "flac"
    "libjpeg"
    "libpng"
    "libwebp"
    "libxslt"
    "opus"
    "snappy"
    "zlib"
  ];

  opusWithCustomModes = libopus.override {
    withCustomModes = true;
  };

  defaultDependencies = [
    bzip2 flac speex opusWithCustomModes
    libevent expat libjpeg snappy
    libpng libcap
    xdg_utils minizip libwebp
    libusb1 re2
    ffmpeg libxslt libxml2
    nasm
  ];

  # build paths and release info
  packageName = extraAttrs.packageName or extraAttrs.name;
  buildType = "Release";
  buildPath = "out/${buildType}";
  libExecPath = "$out/libexec/${packageName}";

  versionRange = min-version: upto-version:
    let inherit (upstream-info) version;
        result = versionAtLeast version min-version && versionOlder version upto-version;
        stable-version = (importJSON ./upstream-info.json).stable.version;
    in if versionAtLeast stable-version upto-version
       then warn "chromium: stable version ${stable-version} is newer than a patchset bounded at ${upto-version}. You can safely delete it."
            result
       else result;

  ungoogler = ungoogled-chromium {
    inherit (upstream-info.deps.ungoogled-patches) rev sha256;
  };

  base = rec {
    name = "${packageName}-unwrapped-${version}";
    inherit (upstream-info) version;
    inherit channel packageName buildType buildPath;

    src = fetchurl {
      url = "https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${version}.tar.xz";
      inherit (upstream-info) sha256;
    };

    nativeBuildInputs = [
      llvmPackages.lldClang.bintools
      ninja which python2Packages.python perl pkgconfig
      python2Packages.ply python2Packages.jinja2 nodejs
      gnutar python2Packages.setuptools
    ];

    buildInputs = defaultDependencies ++ [
      nspr nss systemd
      util-linux alsaLib
      bison gperf kerberos
      glib gtk3 dbus-glib
      libXScrnSaver libXcursor libXtst libxshmfence libGLU libGL
      pciutils protobuf speechd libXdamage at-spi2-core
      jre
      pipewire_0_2
      libva
    ] ++ optional gnomeKeyringSupport libgnome-keyring3
      ++ optionals gnomeSupport [ gnome.GConf libgcrypt ]
      ++ optionals cupsSupport [ libgcrypt cups ]
      ++ optional pulseSupport libpulseaudio
      ++ optionals useOzone [ libdrm wayland mesa.drivers libxkbcommon ];

    patches = [
      ./patches/no-build-timestamps.patch # Optional patch to use SOURCE_DATE_EPOCH in compute_build_timestamp.py (should be upstreamed)
      ./patches/widevine-79.patch # For bundling Widevine (DRM), might be replaceable via bundle_widevine_cdm=true in gnFlags
      # ++ optional (versionRange "68" "72") ( githubPatch "<patch>" "0000000000000000000000000000000000000000000000000000000000000000" )
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

      # We want to be able to specify where the sandbox is via CHROME_DEVEL_SANDBOX
      substituteInPlace sandbox/linux/suid/client/setuid_sandbox_host.cc \
        --replace \
          'return sandbox_binary;' \
          'return base::FilePath(GetDevelSandboxPath());'

      substituteInPlace services/audio/audio_sandbox_hook_linux.cc \
        --replace \
          '/usr/share/alsa/' \
          '${alsaLib}/share/alsa/' \
        --replace \
          '/usr/lib/x86_64-linux-gnu/gconv/' \
          '${glibc}/lib/gconv/' \
        --replace \
          '/usr/share/locale/' \
          '${glibc}/share/locale/'

      sed -i -e 's@"\(#!\)\?.*xdg-@"\1${xdg_utils}/bin/xdg-@' \
        chrome/browser/shell_integration_linux.cc

      sed -i -e '/lib_loader.*Load/s!"\(libudev\.so\)!"${lib.getLib systemd}/lib/\1!' \
        device/udev_linux/udev?_loader.cc

      sed -i -e '/libpci_loader.*Load/s!"\(libpci\.so\)!"${pciutils}/lib/\1!' \
        gpu/config/gpu_info_collector_linux.cc

      # Allow to put extensions into the system-path.
      sed -i -e 's,/usr,/run/current-system/sw,' chrome/common/chrome_paths.cc

      patchShebangs .
      # use our own nodejs
      mkdir -p third_party/node/linux/node-linux-x64/bin
      ln -s "$(command -v node)" third_party/node/linux/node-linux-x64/bin/node

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
      custom_toolchain = "//build/toolchain/linux/unbundle:default";
      host_toolchain = "//build/toolchain/linux/unbundle:default";
      is_official_build = true;

      use_vaapi = !stdenv.isAarch64; # TODO: Remove once M88 is released
      use_sysroot = false;
      use_gnome_keyring = gnomeKeyringSupport;
      use_gio = gnomeSupport;
      # ninja: error: '../../native_client/toolchain/linux_x86/pnacl_newlib/bin/x86_64-nacl-objcopy',
      # needed by 'nacl_irt_x86_64.nexe', missing and no known rule to make it
      enable_nacl = false;
      # Enabling the Widevine component here doesn't affect whether we can
      # redistribute the chromium package; the Widevine component is either
      # added later in the wrapped -wv build or downloaded from Google.
      enable_widevine = true;
      use_cups = cupsSupport;
      # Provides the enable-webrtc-pipewire-capturer flag to support Wayland screen capture.
      rtc_use_pipewire = true;

      treat_warnings_as_errors = false;
      clang_use_chrome_plugins = false;
      blink_symbol_level = 0;
      symbol_level = 0;
      fieldtrial_testing_like_official_build = true;

      # Google API keys, see:
      #   http://www.chromium.org/developers/how-tos/api-keys
      # Note: These are for NixOS/nixpkgs use ONLY. For your own distribution,
      # please get your own set of keys.
      google_api_key = "AIzaSyDGi15Zwl11UNe6Y-5XW_upsfyw31qwZPI";
      google_default_client_id = "404761575300.apps.googleusercontent.com";
      google_default_client_secret = "9rIFQjfnkykEmqb6FfjJQD1D";
    } // optionalAttrs proprietaryCodecs {
      # enable support for the H.264 codec
      proprietary_codecs = true;
      enable_hangout_services_extension = true;
      ffmpeg_branding = "Chrome";
    } // optionalAttrs pulseSupport {
      use_pulseaudio = true;
      link_pulseaudio = true;
    } // optionalAttrs useOzone {
      use_ozone = true;
      use_xkbcommon = true;
      use_glib = true;
      use_gtk = true;
      use_system_libwayland = true;
      use_system_minigbm = true;
      use_system_libdrm = true;
      system_wayland_scanner_path = "${wayland}/bin/wayland-scanner";
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
      python build/linux/unbundle/replace_gn_files.py --system-libraries ${toString gnSystemLibraries}
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
