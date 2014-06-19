{ stdenv, fetchurl, ninja, which

# default dependencies
, bzip2, flac, speex, icu, libopus
, libevent, expat, libjpeg, snappy
, libpng, libxml2, libxslt
, xdg_utils, yasm, minizip, libwebp
, libusb1, libexif, pciutils

, python, pythonPackages, perl, pkgconfig
, nspr, udev, krb5
, utillinux, alsaLib
, gcc, bison, gperf
, glib, gtk, dbus_glib
, libXScrnSaver, libXcursor, libXtst, mesa
, protobuf, speechd, libXdamage

# optional dependencies
, libgcrypt ? null # gnomeSupport || cupsSupport

# package customization
, enableSELinux ? false, libselinux ? null
, enableNaCl ? false
, useOpenSSL ? false, nss ? null, openssl ? null
, gnomeSupport ? false, gnome ? null
, gnomeKeyringSupport ? false, libgnome_keyring3 ? null
, proprietaryCodecs ? true
, cupsSupport ? false
, pulseSupport ? false, pulseaudio ? null

, source
, plugins
}:

buildFun:

with stdenv.lib;

let
  # The additional attributes for creating derivations based on the chromium
  # source tree.
  extraAttrs = buildFun base;

  mkGypFlags =
    let
      sanitize = value:
        if value == true then "1"
        else if value == false then "0"
        else "${value}";
      toFlag = key: value: "-D${key}=${sanitize value}";
    in attrs: concatStringsSep " " (attrValues (mapAttrs toFlag attrs));

  gypFlagsUseSystemLibs = {
    use_system_bzip2 = true;
    use_system_flac = true;
    use_system_libevent = true;
    use_system_libexpat = true;
    use_system_libexif = true;
    use_system_libjpeg = true;
    use_system_libpng = true;
    use_system_libwebp = true;
    use_system_libxml = true;
    use_system_opus = true;
    use_system_snappy = true;
    use_system_speex = true;
    use_system_ssl = useOpenSSL;
    use_system_stlport = true;
    use_system_xdg_utils = true;
    use_system_yasm = true;
    use_system_zlib = false;
    use_system_protobuf = true;

    use_system_harfbuzz = false;
    use_system_icu = false; # Doesn't support ICU 52 yet.
    use_system_libusb = false; # http://crbug.com/266149
    use_system_skia = false;
    use_system_sqlite = false; # http://crbug.com/22208
    use_system_v8 = false;
  };

  opusWithCustomModes = libopus.override {
    withCustomModes = !versionOlder source.version "35.0.0.0";
  };

  defaultDependencies = [
    bzip2 flac speex icu opusWithCustomModes
    libevent expat libjpeg snappy
    libpng libxml2 libxslt
    xdg_utils yasm minizip libwebp
    libusb1 libexif
  ];

  # build paths and release info
  packageName = extraAttrs.packageName or extraAttrs.name;
  buildType = "Release";
  buildPath = "out/${buildType}";
  libExecPath = "$out/libexec/${packageName}";

  base = rec {
    name = "${packageName}-${version}";
    inherit (source) version;
    inherit packageName buildType buildPath;
    src = source;

    buildInputs = defaultDependencies ++ [
      which
      python perl pkgconfig
      nspr udev
      (if useOpenSSL then openssl else nss)
      utillinux alsaLib
      gcc bison gperf krb5
      glib gtk dbus_glib
      libXScrnSaver libXcursor libXtst mesa
      pciutils protobuf speechd libXdamage
      pythonPackages.gyp pythonPackages.ply pythonPackages.jinja2
    ] ++ optional gnomeKeyringSupport libgnome_keyring3
      ++ optionals gnomeSupport [ gnome.GConf libgcrypt ]
      ++ optional enableSELinux libselinux
      ++ optional cupsSupport libgcrypt
      ++ optional pulseSupport pulseaudio;

    # XXX: Wait for https://crbug.com/239107 and https://crbug.com/239181 to
    #      be fixed, then try again to unbundle everything into separate
    #      derivations.
    prePatch = ''
      cp -dsr --no-preserve=mode "${source.main}"/* .
      cp -dsr --no-preserve=mode "${source.sandbox}" sandbox
      cp -dr "${source.bundled}" third_party
      chmod -R u+w third_party

      # Hardcode source tree root in all gyp files
      find -iname '*.gyp*' \( -type f -o -type l \) \
        -exec sed -i -e 's|<(DEPTH)|'"$(pwd)"'|g' {} + \
        -exec chmod u+w {} +
    '' + optionalString (!versionOlder source.version "37.0.0.0") ''
      python third_party/libaddressinput/chromium/tools/update-strings.py
    '';

    postPatch = let
      toPatch = if versionOlder source.version "36.0.0.0"
                then "content/browser/browser_main_loop.cc"
                else "sandbox/linux/suid/client/setuid_sandbox_client.cc";
    in ''
      sed -i -e '/base::FilePath exe_dir/,/^ *} *$/c \
        sandbox_binary = base::FilePath(getenv("CHROMIUM_SANDBOX_BINARY_PATH"));
      ' ${toPatch}
    '' + optionalString (!versionOlder source.version "36.0.0.0") ''
      sed -i -e '/module_path *=.*libexif.so/ {
        s|= [^;]*|= base::FilePath().AppendASCII("${libexif}/lib/libexif.so")|
      }' chrome/utility/media_galleries/image_metadata_extractor.cc
    '';

    gypFlags = mkGypFlags (gypFlagsUseSystemLibs // {
      linux_use_gold_binary = false;
      linux_use_gold_flags = false;
      proprietary_codecs = false;
      use_gnome_keyring = gnomeKeyringSupport;
      use_gconf = gnomeSupport;
      use_gio = gnomeSupport;
      use_pulseaudio = pulseSupport;
      linux_link_pulseaudio = pulseSupport;
      disable_nacl = !enableNaCl;
      use_openssl = useOpenSSL;
      selinux = enableSELinux;
      use_cups = cupsSupport;
      linux_sandbox_chrome_path="${libExecPath}/${packageName}";
      werror = "";

      # FIXME: In version 37, omnibox.mojom.js doesn't seem to be generated.
      use_mojo = versionOlder source.version "37.0.0.0";

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
      ffmpeg_branding = "Chrome";
    } // optionalAttrs (stdenv.system == "x86_64-linux") {
      target_arch = "x64";
      python_arch = "x86-64";
    } // optionalAttrs (stdenv.system == "i686-linux") {
      target_arch = "ia32";
      python_arch = "ia32";
    } // (extraAttrs.gypFlags or {}));

    configurePhase = ''
      # This is to ensure expansion of $out.
      libExecPath="${libExecPath}"
      python build/linux/unbundle/replace_gyp_files.py ${gypFlags}
      python build/gyp_chromium -f ninja --depth "$(pwd)" ${gypFlags}
    '';

    buildPhase = let
      CC = "${gcc}/bin/gcc";
      CXX = "${gcc}/bin/g++";
      buildCommand = target: let
        # XXX: Only needed for version 36 and older!
        targetSuffix = optionalString
          (versionOlder source.version "37.0.0.0" && target == "mksnapshot")
          (if stdenv.is64bit then ".x64" else ".ia32");
      in ''
        CC="${CC}" CC_host="${CC}"     \
        CXX="${CXX}" CXX_host="${CXX}" \
        LINK_host="${CXX}"             \
          "${ninja}/bin/ninja" -C "${buildPath}"  \
            -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES \
            "${target}${targetSuffix}"
      '' + optionalString (target == "mksnapshot" || target == "chrome") ''
        paxmark m "${buildPath}/${target}${targetSuffix}"
      '';
      targets = extraAttrs.buildTargets or [];
      commands = map buildCommand targets;
    in concatStringsSep "\n" commands;
  };

# Remove some extraAttrs we supplied to the base attributes already.
in stdenv.mkDerivation (base // removeAttrs extraAttrs [
  "name" "gypFlags" "buildTargets"
])
