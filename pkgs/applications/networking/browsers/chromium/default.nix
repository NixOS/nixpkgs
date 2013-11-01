{ stdenv, fetchurl, makeWrapper, ninja, which

# default dependencies
, bzip2, flac, speex
, libevent, expat, libjpeg
, libpng, libxml2, libxslt
, xdg_utils, yasm, zlib
, libusb1, libexif, pciutils

, python, pythonPackages, perl, pkgconfig
, nspr, udev, krb5, file
, utillinux, alsaLib
, gcc, bison, gperf
, glib, gtk, dbus_glib
, libXScrnSaver, libXcursor, libXtst, mesa
, protobuf, speechd, libXdamage

# optional dependencies
, libgcrypt ? null # gnomeSupport || cupsSupport

# package customization
, channel ? "stable"
, enableSELinux ? false, libselinux ? null
, enableNaCl ? false
, useOpenSSL ? false, nss ? null, openssl ? null
, gnomeSupport ? false, gconf ? null
, gnomeKeyringSupport ? false, libgnome_keyring ? null
, proprietaryCodecs ? true
, cupsSupport ? false
, pulseSupport ? false, pulseaudio ? null
}:

with stdenv.lib;

let
  src = with getAttr channel (import ./sources.nix); stdenv.mkDerivation {
    name = "chromium-source-${version}";

    src = fetchurl {
      inherit url sha256;
    };

    phases = [ "unpackPhase" "patchPhase" "installPhase" ];

    opensslPatches = optional useOpenSSL openssl.patches;

    prePatch = "patchShebangs .";

    patches = singleton (
      if versionOlder version "31.0.0.0"
      then ./sandbox_userns_30.patch
      else ./sandbox_userns_31.patch
    );

    postPatch = ''
      sed -i -r -e 's/-f(stack-protector)(-all)?/-fno-\1/' build/common.gypi
      sed -i -e 's|/usr/bin/gcc|gcc|' third_party/WebKit/Source/core/core.gypi
    '' + optionalString useOpenSSL ''
      cat $opensslPatches | patch -p1 -d third_party/openssl/openssl
    '';

    outputs = [ "out" "sandbox" "bundled" "main" ];
    installPhase = ''
      ensureDir "$out" "$sandbox" "$bundled" "$main"

      header "copying browser main sources to $main"
      find . -mindepth 1 -maxdepth 1 \
        \! -path ./sandbox \
        \! -path ./third_party \
        \! -path ./build \
        \! -path ./tools \
        \! -name '.*' \
        -print | xargs cp -rt "$main"
      stopNest

      header "copying sandbox components to $sandbox"
      cp -rt "$sandbox" sandbox/*
      stopNest

      header "copying third party sources to $bundled"
      cp -rt "$bundled" third_party/*
      stopNest

      header "copying build requisites to $out"
      cp -rt "$out" build tools
      stopNest

      rm -rf "$out/tools/gyp" # XXX: Don't even copy it in the first place.
    '';

    passthru = {
      inherit version;
    };
  };

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
    use_system_libpng = false; # PNG dlopen() version conflict
    use_system_libusb = true;
    use_system_libxml = true;
    use_system_speex = true;
    use_system_ssl = useOpenSSL;
    use_system_stlport = true;
    use_system_xdg_utils = true;
    use_system_yasm = true;
    use_system_zlib = false; # http://crbug.com/143623
    use_system_protobuf = true;

    use_system_harfbuzz = false;
    use_system_icu = false;
    use_system_libwebp = false; # http://crbug.com/133161
    use_system_skia = false;
    use_system_sqlite = false; # http://crbug.com/22208
    use_system_v8 = false;
  };

  defaultDependencies = [
    bzip2 flac speex
    libevent expat libjpeg
    libpng libxml2 libxslt
    xdg_utils yasm zlib
    libusb1 libexif
  ];

  sandbox = import ./sandbox.nix {
    inherit stdenv;
    src = src.sandbox;
    binary = "${packageName}_sandbox";
  };

  # build paths and release info
  packageName = "chromium";
  buildType = "Release";
  buildPath = "out/${buildType}";
  libExecPath = "$out/libexec/${packageName}";
  sandboxPath = "${sandbox}/bin/${packageName}_sandbox";

in stdenv.mkDerivation rec {
  name = "${packageName}-${src.version}";
  inherit packageName src;

  buildInputs = defaultDependencies ++ [
    which makeWrapper
    python perl pkgconfig
    nspr udev
    (if useOpenSSL then openssl else nss)
    utillinux alsaLib
    gcc bison gperf
    krb5 file
    glib gtk dbus_glib
    libXScrnSaver libXcursor libXtst mesa
    pciutils protobuf speechd libXdamage
    pythonPackages.gyp
  ] ++ optional gnomeKeyringSupport libgnome_keyring
    ++ optionals gnomeSupport [ gconf libgcrypt ]
    ++ optional enableSELinux libselinux
    ++ optional cupsSupport libgcrypt
    ++ optional pulseSupport pulseaudio;

  prePatch = ''
    # XXX: Figure out a way how to split these properly.
    #cpflags="-dsr --no-preserve=mode"
    cpflags="-dr"
    cp $cpflags "${src.main}"/* .
    cp $cpflags "${src.bundled}" third_party
    cp $cpflags "${src.sandbox}" sandbox
    chmod -R u+w . # XXX!
  '';

  postPatch = ''
    sed -i -e '/base::FilePath exe_dir/,/^ *} *$/c \
      sandbox_binary = \
        base::FilePath("'"${sandboxPath}"'");
    ' content/browser/browser_main_loop.cc
  '';

  gypFlags = mkGypFlags (gypFlagsUseSystemLibs // {
    linux_use_gold_binary = false;
    linux_use_gold_flags = false;
    proprietary_codecs = false;
    use_gnome_keyring = gnomeKeyringSupport;
    use_gconf = gnomeSupport;
    use_gio = gnomeSupport;
    use_pulseaudio = pulseSupport;
    disable_nacl = !enableNaCl;
    use_openssl = useOpenSSL;
    selinux = enableSELinux;
    use_cups = cupsSupport;
    linux_sandbox_path="${sandboxPath}";
    linux_sandbox_chrome_path="${libExecPath}/${packageName}";
    werror = "";

    # Google API keys, see http://www.chromium.org/developers/how-tos/api-keys.
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
  } // optionalAttrs (stdenv.system == "i686-linux") {
    target_arch = "ia32";
  });

  configurePhase = ''
    python build/gyp_chromium -f ninja --depth "$(pwd)" ${gypFlags}
  '';

  buildPhase = let
    CC = "${gcc}/bin/gcc";
    CXX = "${gcc}/bin/g++";
  in ''
    CC="${CC}" CC_host="${CC}"     \
    CXX="${CXX}" CXX_host="${CXX}" \
    LINK_host="${CXX}"             \
      "${ninja}/bin/ninja" -C "${buildPath}"  \
        -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES \
        chrome ${optionalString (!enableSELinux) "chrome_sandbox"}
  '';

  installPhase = ''
    ensureDir "${libExecPath}"
    cp -v "${buildPath}/"*.pak "${libExecPath}/"
    cp -vR "${buildPath}/locales" "${buildPath}/resources" "${libExecPath}/"
    cp -v ${buildPath}/libffmpegsumo.so "${libExecPath}/"

    cp -v "${buildPath}/chrome" "${libExecPath}/${packageName}"

    mkdir -vp "$out/bin"
    makeWrapper "${libExecPath}/${packageName}" "$out/bin/${packageName}"

    mkdir -vp "$out/share/man/man1"
    cp -v "${buildPath}/chrome.1" "$out/share/man/man1/${packageName}.1"

    for icon_file in chrome/app/theme/chromium/product_logo_*[0-9].png; do
      num_and_suffix="''${icon_file##*logo_}"
      icon_size="''${num_and_suffix%.*}"
      expr "$icon_size" : "^[0-9][0-9]*$" || continue
      logo_output_prefix="$out/share/icons/hicolor"
      logo_output_path="$logo_output_prefix/''${icon_size}x''${icon_size}/apps"
      mkdir -vp "$logo_output_path"
      cp -v "$icon_file" "$logo_output_path/${packageName}.png"
    done
  '';

  passthru = {
    inherit sandbox;
  };

  meta = {
    description = "An open source web browser from Google";
    homepage = http://www.chromium.org/;
    maintainers = with maintainers; [ goibhniu chaoflow aszlig ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
