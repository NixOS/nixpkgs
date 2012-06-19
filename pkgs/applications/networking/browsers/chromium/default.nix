{ stdenv, fetchurl, fetchsvn, makeWrapper, which

# default dependencies
, bzip2, ffmpeg, flac #, harfbuzz
, icu, libevent, expat, libjpeg
, libpng, libwebp, libxml2, libxslt #, skia
, speex, sqlite, openssl #, stlport
, v8, xdg_utils, yasm, zlib

, python, perl, pkgconfig
, nspr, udev
, utillinux, alsaLib
, gcc, bison, gperf
, krb5
, glib, gtk, gconf, libgcrypt, libgnome_keyring, dbus_glib
, libXScrnSaver, libXcursor

, useSELinux ? false
, naclSupport ? false
, gnomeKeyringSupport ? false
, useProprietaryCodecs ? false
}:

let
  sourceInfo = import ./source.nix;

  mkGypFlags = with stdenv.lib; let
    sanitize = value:
      if value == true then "1"
      else if value == false then "0"
      else "${value}";
    toFlag = key: value: "-D${key}=${sanitize value}";
  in attrs: concatStringsSep " " (attrValues (mapAttrs toFlag attrs));

  gypFlagsUseSystemLibs = {
    use_system_bzip2 = true;
    use_system_ffmpeg = false; # FIXME: libavformat...
    use_system_flac = true;
    use_system_harfbuzz = false; # TODO
    use_system_icu = false; # FIXME: wrong version!
    use_system_libevent = true;
    use_system_libexpat = true;
    use_system_libjpeg = true;
    use_system_libpng = true;
    use_system_libwebp = false; # See chromium issue #133161
    use_system_libxml = true;
    use_system_skia = false; # TODO
    use_system_speex = true;
    use_system_sqlite = false; # FIXME
    use_system_ssl = true;
    use_system_stlport = true;
    use_system_v8 = false; # TODO...
    use_system_xdg_utils = true;
    use_system_yasm = true;
    use_system_zlib = true;
  };

  defaultDependencies = [
    bzip2 ffmpeg flac # harfbuzz
    icu libevent expat libjpeg
    libpng libwebp libxml2 libxslt # skia
    speex sqlite openssl # stlport
    v8 xdg_utils yasm zlib
  ];

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
    utillinux alsaLib
    gcc bison gperf
    krb5
    glib gtk gconf libgcrypt dbus_glib
    libXScrnSaver libXcursor
  ] ++ stdenv.lib.optional gnomeKeyringSupport libgnome_keyring;

  prePatch = "patchShebangs .";

  patches = stdenv.lib.optional (!useSELinux) ./enable_seccomp.patch;

  gypFlags = mkGypFlags (gypFlagsUseSystemLibs // {
    linux_use_gold_binary = false;
    linux_use_gold_flags = false;
    proprietary_codecs = false;
    use_gnome_keyring = gnomeKeyringSupport;
    disable_nacl = !naclSupport;
    use_openssl = true;
    selinux = useSELinux;
    use_cups = false;
  } // stdenv.lib.optionalAttrs (stdenv.system == "x86_64-linux") {
    target_arch = "x64";
  } // stdenv.lib.optionalAttrs (stdenv.system == "i686-linux") {
    target_arch = "ia32";
  });

  buildType = "Release";

  configurePhase = ''
    python build/gyp_chromium --depth "$(pwd)" ${gypFlags}
  '';

  extraBuildFlags = let
    CC = "${gcc}/bin/gcc";
    CXX = "${gcc}/bin/g++";
  in "CC=\"${CC}\" CXX=\"${CXX}\" CC.host=\"${CC}\" CXX.host=\"${CXX}\" LINK.host=\"${CXX}\"";

  buildPhase = ''
    make ${extraBuildFlags} BUILDTYPE=${buildType} library=shared_library chrome
  '';

  installPhase = ''
    mkdir -vp "$out/libexec/${packageName}"
    cp -v "out/${buildType}/"*.pak "$out/libexec/${packageName}/"
    cp -vR "out/${buildType}/locales" "out/${buildType}/resources" "$out/libexec/${packageName}/"

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
  };
}
