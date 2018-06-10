{ stdenv, fetchurl, fetchpatch
, dbus-glib, gtk2, gtk3, libexif, libpulseaudio, libXScrnSaver, ninja, nss
, pciutils, pkgconfig, python2, xdg_utils
}:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "vivaldi-ffmpeg-codecs";
  version = "61.0.3163.91";

  src = fetchurl {
    url = "https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${version}.tar.xz";
    sha512 = "3f07vwbxllrwy3agqxa6ndcix23vai18i178zscmk0y68flhzffyjdvrwlg7dzlwgiqypj2cyl21qb4qmcay2ilgw9vnr9fql2x0w7p";
  };

  buildInputs = [ ];

  nativeBuildInputs = [
    dbus-glib gtk2 gtk3 libexif libpulseaudio libXScrnSaver ninja nss pciutils pkgconfig
    python2 xdg_utils
  ];

  patches = [
    ./chromium-gn-bootstrap-r14.patch
    ./chromium-gcc-r1.patch
    ./chromium-gcc5-r1.patch
  ];

  configurePhase = ''
    runHook preConfigure

    local args="ffmpeg_branding=\"ChromeOS\" proprietary_codecs=true enable_hevc_demuxing=true use_gconf=false use_gio=false use_gnome_keyring=false use_kerberos=false use_cups=false use_sysroot=false use_gold=false linux_use_bundled_binutils=false fatal_linker_warnings=false treat_warnings_as_errors=false is_clang=false is_component_build=true is_debug=false symbol_level=0"
    python tools/gn/bootstrap/bootstrap.py -v -s --no-clean --gn-gen-args "$args"
    out/Release/gn gen out/Release -v --args="$args"

    runHook postConfigure
  '';

  buildPhase = ''
    ninja -C out/Release -v libffmpeg.so
  '';

  dontStrip = true;

  installPhase = ''
    mkdir -p "$out/lib"
    cp out/Release/libffmpeg.so "$out/lib/libffmpeg.so"
  '';

  meta = with stdenv.lib; {
    description = "Additional support for proprietary codecs for Vivaldi";
    homepage    = "https://ffmpeg.org/";
    license     = licenses.lgpl21;
    maintainers = with maintainers; [ lluchs ];
    platforms   = [ "x86_64-linux" ];
    broken = true;
  };
}
