{ stdenv, fetchurl
, dbus-glib, gtk3, libexif, libXScrnSaver, ninja, nss
, pciutils, pkgconfig, python2, xdg_utils, gn, at-spi2-core
}:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "vivaldi-ffmpeg-codecs";
  version = "71.0.3578.98";

  src = fetchurl {
    url = "https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${version}.tar.xz";
    sha512 = "3baldqqdm8jzrs37w756ijgzwpmvma73rqbpnfkf0j41rmikrjdl6w7ycll98jch8rhzpgz3yfb9nk0gmsgxs233wn441bcdkhr1syv";
  };

  buildInputs = [ ];

  nativeBuildInputs = [
    gtk3 libexif libXScrnSaver ninja nss pciutils python2 xdg_utils gn
    pkgconfig dbus-glib at-spi2-core.dev
  ];

  patches = [
  ];

  configurePhase = ''
    runHook preConfigure

    local args="ffmpeg_branding=\"ChromeOS\" proprietary_codecs=true enable_hevc_demuxing=true use_gnome_keyring=false use_sysroot=false use_gold=false use_allocator=\"none\" linux_use_bundled_binutils=false fatal_linker_warnings=false treat_warnings_as_errors=false enable_nacl=false enable_nacl_nonsfi=false is_clang=false clang_use_chrome_plugins=false is_component_build=true is_debug=false symbol_level=0 use_custom_libcxx=false use_lld=false use_jumbo_build=false"
    gn gen out/Release -v --args="$args"

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
  };
}
