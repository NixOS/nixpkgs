{ stdenv, gn, ninja, which

# default dependencies
, bzip2, flac, speex, libopus
, libevent, expat, libjpeg, snappy
, libpng, libxml2, libxslt, libcap
, xdg_utils, yasm, minizip, libwebp
, libusb1, pciutils, nss, re2, zlib, libvpx

, python, pythonPackages, perl, pkgconfig
, nspr, systemd, kerberos
, utillinux, alsaLib
, bison, gperf
, glib, gtk2, dbus_glib
, libXScrnSaver, libXcursor, libXtst, mesa
, protobuf, speechd, libXdamage, cups

# optional dependencies
, libgcrypt ? null # gnomeSupport || cupsSupport
, libexif ? null # only needed for Chromium before version 51

# package customization
, enableSELinux ? false, libselinux ? null
, enableNaCl ? false
, enableHotwording ? false
, gnomeSupport ? false, gnome ? null
, gnomeKeyringSupport ? false, libgnome_keyring3 ? null
, proprietaryCodecs ? true
, cupsSupport ? true
, pulseSupport ? false, libpulseaudio ? null
, hiDPISupport ? false

, upstream-info
}:

buildFun:

with stdenv.lib;

let
  # The additional attributes for creating derivations based on the chromium
  # source tree.
  extraAttrs = buildFun base;

  mkGnFlags =
    let
      # Serialize Nix types into GN types according to this document:
      # https://chromium.googlesource.com/chromium/src/+/master/tools/gn/docs/language.md
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

  gnSystemLibraries = [
    "flac" "libjpeg" "libpng" "libvpx" "libwebp" "libxml" "libxslt" "re2"
    "snappy" "yasm" "zlib"
  ];

  opusWithCustomModes = libopus.override {
    withCustomModes = true;
  };

  defaultDependencies = [
    bzip2 flac speex opusWithCustomModes
    libevent expat libjpeg snappy
    libpng libxml2 libxslt libcap
    xdg_utils yasm minizip libwebp
    libusb1 re2 zlib libvpx
  ];

  # build paths and release info
  packageName = extraAttrs.packageName or extraAttrs.name;
  buildType = "Release";
  buildPath = "out/${buildType}";
  libExecPath = "$out/libexec/${packageName}";

  base = rec {
    name = "${packageName}-${version}";
    inherit (upstream-info) version;
    inherit packageName buildType buildPath;

    src = upstream-info.main;

    nativeBuildInputs = [ gn which python perl pkgconfig ];

    buildInputs = defaultDependencies ++ [
      nspr nss systemd
      utillinux alsaLib
      bison gperf kerberos
      glib gtk2 dbus_glib
      libXScrnSaver libXcursor libXtst mesa
      pciutils protobuf speechd libXdamage
      pythonPackages.ply pythonPackages.jinja2
    ] ++ optional gnomeKeyringSupport libgnome_keyring3
      ++ optionals gnomeSupport [ gnome.GConf libgcrypt ]
      ++ optional enableSELinux libselinux
      ++ optionals cupsSupport [ libgcrypt cups ]
      ++ optional pulseSupport libpulseaudio;

    patches = [
      ./patches/widevine.patch
      ./patches/glibc-2.24.patch
      ./patches/nix_plugin_paths_52.patch
    ];

    postPatch = ''
      # We want to be able to specify where the sandbox is via CHROME_DEVEL_SANDBOX
      substituteInPlace sandbox/linux/suid/client/setuid_sandbox_host.cc \
        --replace \
          'return sandbox_binary;' \
          'return base::FilePath(GetDevelSandboxPath());'

      sed -i -e '/lib_loader.*Load/s!"\(libudev\.so\)!"${systemd.lib}/lib/\1!' \
        device/udev_linux/udev?_loader.cc

      sed -i -e '/libpci_loader.*Load/s!"\(libpci\.so\)!"${pciutils}/lib/\1!' \
        gpu/config/gpu_info_collector_linux.cc

      sed -i -re 's/([^:])\<(isnan *\()/\1std::\2/g' \
        chrome/browser/ui/webui/engagement/site_engagement_ui.cc

      sed -i -e '/#include/ {
        i #include <algorithm>
        :l; n; bl
      }' gpu/config/gpu_control_list.cc

      patchShebangs .
    '' + optionalString (versionAtLeast version "52.0.0.0") ''
      sed -i -re 's/([^:])\<(isnan *\()/\1std::\2/g' \
        third_party/pdfium/xfa/fxbarcode/utils.h
    '';

    gnFlags = mkGnFlags ({
      linux_use_bundled_binutils = false;
      linux_use_bundled_gold = false;
      linux_use_gold_flags = true;
      is_debug = false;

      proprietary_codecs = false;
      use_sysroot = false;
      use_gnome_keyring = gnomeKeyringSupport;
      use_gconf = gnomeSupport;
      use_gio = gnomeSupport;
      enable_nacl = enableNaCl;
      enable_hotwording = enableHotwording;
      selinux = enableSELinux;
      use_cups = cupsSupport;
    } // {
      treat_warnings_as_errors = false;
      is_clang = false;
      enable_hidpi = hiDPISupport;

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
    } // (extraAttrs.gnFlags or {}));

    configurePhase = ''
      # This is to ensure expansion of $out.
      libExecPath="${libExecPath}"
      python build/linux/unbundle/replace_gn_files.py \
        --system-libraries ${toString gnSystemLibraries}
      gn gen --args=${escapeShellArg gnFlags} out/Release
    '';

    buildPhase = let
      buildCommand = target: ''
        "${ninja}/bin/ninja" -C "${buildPath}"  \
          -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES \
          "${target}"
      '' + optionalString (target == "mksnapshot" || target == "chrome") ''
        paxmark m "${buildPath}/${target}"
      '';
      targets = extraAttrs.buildTargets or [];
      commands = map buildCommand targets;
    in concatStringsSep "\n" commands;
  };

# Remove some extraAttrs we supplied to the base attributes already.
in stdenv.mkDerivation (base // removeAttrs extraAttrs [
  "name" "gnFlags" "buildTargets"
])
