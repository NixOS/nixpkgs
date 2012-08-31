{ stdenv, getConfig, fetchurl, makeWrapper, which

# default dependencies
, bzip2, flac, speex
, libevent, expat, libjpeg
, libpng, libxml2, libxslt
, xdg_utils, yasm, zlib

, python, perl, pkgconfig
, nspr, udev, krb5
, utillinux, alsaLib
, gcc, bison, gperf
, glib, gtk, dbus_glib
, libXScrnSaver, libXcursor, mesa

# optional dependencies
, libgnome_keyring # config.gnomeKeyring
, gconf # config.gnome
, libgcrypt # config.gnome || config.cups
, nss, openssl # config.openssl
, pulseaudio # config.pulseaudio
, libselinux # config.selinux
}:

let
  mkConfigurable = stdenv.lib.mapAttrs (flag: default: getConfig ["chromium" flag] default);

  config = mkConfigurable {
    channel = "stable";
    selinux = false;
    nacl = false;
    openssl = false;
    gnome = false;
    gnomeKeyring = false;
    proprietaryCodecs = true;
    cups = false;
    pulseaudio = getConfig ["pulseaudio"] true;
  };

  sourceInfo = builtins.getAttr config.channel (import ./sources.nix);

  mkGypFlags = with stdenv.lib; let
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
    use_system_libjpeg = true;
    use_system_libpng = true;
    use_system_libxml = true;
    use_system_speex = true;
    use_system_ssl = config.openssl;
    use_system_stlport = true;
    use_system_xdg_utils = true;
    use_system_yasm = true;
    use_system_zlib = true;

    use_system_harfbuzz = false;
    use_system_icu = false;
    use_system_libwebp = false; # See chromium issue #133161
    use_system_skia = false;
    use_system_sqlite = false; # See chromium issue #22208
    use_system_v8 = false;
  };

  defaultDependencies = [
    bzip2 flac speex
    libevent expat libjpeg
    libpng libxml2 libxslt
    xdg_utils yasm zlib
  ];

  seccompPatch = let
    pre22 = stdenv.lib.versionOlder sourceInfo.version "22.0.0.0";
  in if pre22 then ./enable_seccomp.patch else ./enable_seccomp22.patch;

in stdenv.mkDerivation rec {
  name = "${packageName}-${version}";
  packageName = "chromium";

  version = sourceInfo.version;

  src = fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.sha256;
  };

  buildInputs = defaultDependencies ++ [
    which makeWrapper
    python perl pkgconfig
    nspr udev
    (if config.openssl then openssl else nss)
    utillinux alsaLib
    gcc bison gperf
    krb5
    glib gtk dbus_glib
    libXScrnSaver libXcursor mesa
  ] ++ stdenv.lib.optional config.gnomeKeyring libgnome_keyring
    ++ stdenv.lib.optionals config.gnome [ gconf libgcrypt ]
    ++ stdenv.lib.optional config.selinux libselinux
    ++ stdenv.lib.optional config.cups libgcrypt
    ++ stdenv.lib.optional config.pulseaudio pulseaudio;

  opensslPatches = stdenv.lib.optional config.openssl openssl.patches;

  prePatch = "patchShebangs .";

  patches = stdenv.lib.optional (!config.selinux) seccompPatch
         ++ stdenv.lib.optional config.cups ./cups_allow_deprecated.patch
         ++ stdenv.lib.optional config.pulseaudio ./pulseaudio_array_bounds.patch;

  postPatch = stdenv.lib.optionalString config.openssl ''
    cat $opensslPatches | patch -p1 -d third_party/openssl/openssl
  '';

  gypFlags = mkGypFlags (gypFlagsUseSystemLibs // {
    linux_use_gold_binary = false;
    linux_use_gold_flags = false;
    proprietary_codecs = false;
    use_gnome_keyring = config.gnomeKeyring;
    use_gconf = config.gnome;
    use_gio = config.gnome;
    use_pulseaudio = config.pulseaudio;
    disable_nacl = !config.nacl;
    use_openssl = config.openssl;
    selinux = config.selinux;
    use_cups = config.cups;
  } // stdenv.lib.optionalAttrs config.proprietaryCodecs {
    # enable support for the H.264 codec
    proprietary_codecs = true;
    ffmpeg_branding = "Chrome";
  } // stdenv.lib.optionalAttrs (stdenv.system == "x86_64-linux") {
    target_arch = "x64";
  } // stdenv.lib.optionalAttrs (stdenv.system == "i686-linux") {
    target_arch = "ia32";
  });

  buildType = "Release";

  enableParallelBuilding = true;

  configurePhase = ''
    python build/gyp_chromium --depth "$(pwd)" ${gypFlags}
  '';

  makeFlags = let
    CC = "${gcc}/bin/gcc";
    CXX = "${gcc}/bin/g++";
  in [
    "CC=${CC}"
    "CXX=${CXX}"
    "CC.host=${CC}"
    "CXX.host=${CXX}"
    "LINK.host=${CXX}"
  ];

  buildFlags = [
    "BUILDTYPE=${buildType}"
    "library=shared_library"
    "chrome"
  ];

  installPhase = ''
    mkdir -vp "$out/libexec/${packageName}"
    cp -v "out/${buildType}/"*.pak "$out/libexec/${packageName}/"
    cp -vR "out/${buildType}/locales" "out/${buildType}/resources" "$out/libexec/${packageName}/"
    cp -v out/${buildType}/libffmpegsumo.so "$out/libexec/${packageName}/"

    cp -v "out/${buildType}/chrome" "$out/libexec/${packageName}/${packageName}"

    mkdir -vp "$out/bin"
    makeWrapper "$out/libexec/${packageName}/${packageName}" "$out/bin/${packageName}"

    mkdir -vp "$out/share/man/man1"
    cp -v "out/${buildType}/chrome.1" "$out/share/man/man1/${packageName}.1"

    for icon_file in chrome/app/theme/chromium/product_logo_*[0-9].png; do
      num_and_suffix="''${icon_file##*logo_}"
      icon_size="''${num_and_suffix%.*}"
      logo_output_path="$out/share/icons/hicolor/''${icon_size}x''${icon_size}/apps"
      mkdir -vp "$logo_output_path"
      cp -v "$icon_file" "$logo_output_path/${packageName}.png"
    done
  '';

  meta =  with stdenv.lib; {
    description = "Chromium, an open source web browser";
    homepage = http://www.chromium.org/;
    maintainers = with stdenv.lib.maintainers; [ goibhniu chaoflow ];
    license = licenses.bsd3;
    platforms = with stdenv.lib.platforms; linux;
  };
}
