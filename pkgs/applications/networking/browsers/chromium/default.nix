{ stdenv, fetchurl, makeWrapper, ninja, which

# default dependencies
, bzip2, flac, speex
, libevent, expat, libjpeg
, libpng, libxml2, libxslt
, xdg_utils, yasm, zlib
, libusb1, libexif, pciutils

, python, perl, pkgconfig
, nspr, udev, krb5
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
  sourceInfo = builtins.getAttr channel (import ./sources.nix);

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

  # build paths and release info
  packageName = "chromium";
  buildType = "Release";
  buildPath = "out/${buildType}";
  libExecPath = "$out/libexec/${packageName}";

  # user namespace sandbox patch
  userns_patch = if versionOlder sourceInfo.version "29.0.0.0"
                 then ./sandbox_userns.patch
                 else ./sandbox_userns_29.patch;

in stdenv.mkDerivation rec {
  name = "${packageName}-${version}";
  inherit packageName;

  version = sourceInfo.version;

  src = fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.sha256;
  };

  buildInputs = defaultDependencies ++ [
    which makeWrapper
    python perl pkgconfig
    nspr udev
    (if useOpenSSL then openssl else nss)
    utillinux alsaLib
    gcc bison gperf
    krb5
    glib gtk dbus_glib
    libXScrnSaver libXcursor libXtst mesa
    pciutils protobuf speechd libXdamage
  ] ++ optional gnomeKeyringSupport libgnome_keyring
    ++ optionals gnomeSupport [ gconf libgcrypt ]
    ++ optional enableSELinux libselinux
    ++ optional cupsSupport libgcrypt
    ++ optional pulseSupport pulseaudio;

  opensslPatches = optional useOpenSSL openssl.patches;

  prePatch = "patchShebangs .";

  patches = [ userns_patch ]
         ++ optional cupsSupport ./cups_allow_deprecated.patch;

  postPatch = ''
    sed -i -r -e 's/-f(stack-protector)(-all)?/-fno-\1/' build/common.gypi
    sed -i -e 's|/usr/bin/gcc|gcc|' third_party/WebKit/Source/core/core.gypi
  '' + optionalString useOpenSSL ''
    cat $opensslPatches | patch -p1 -d third_party/openssl/openssl
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
    linux_sandbox_path="${libExecPath}/${packageName}_sandbox";
    linux_sandbox_chrome_path="${libExecPath}/${packageName}";
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
    GYP_GENERATORS=ninja python build/gyp_chromium --depth "$(pwd)" ${gypFlags}
  '';

  buildPhase = let
    CC = "${gcc}/bin/gcc";
    CXX = "${gcc}/bin/g++";
  in ''
    CC="${CC}" CC_host="${CC}"     \
    CXX="${CXX}" CXX_host="${CXX}" \
    LINK_host="${CXX}"             \
      "${ninja}/bin/ninja" -C "out/${buildType}" \
        -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES    \
        chrome ${optionalString (!enableSELinux) "chrome_sandbox"}
  '';

  installPhase = ''
    mkdir -vp "${libExecPath}"
    cp -v "${buildPath}/"*.pak "${libExecPath}/"
    cp -vR "${buildPath}/locales" "${buildPath}/resources" "${libExecPath}/"
    cp -v ${buildPath}/libffmpegsumo.so "${libExecPath}/"

    cp -v "${buildPath}/chrome" "${libExecPath}/${packageName}"

    mkdir -vp "$out/bin"
    makeWrapper "${libExecPath}/${packageName}" "$out/bin/${packageName}"
    cp -v "${buildPath}/chrome_sandbox" "${libExecPath}/${packageName}_sandbox"

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

  meta = {
    description = "Chromium, an open source web browser";
    homepage = http://www.chromium.org/;
    maintainers = with maintainers; [ goibhniu chaoflow aszlig ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
