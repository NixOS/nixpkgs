{ stdenv, fetchurl, SDL, perl, curl, libpng, libjpeg, fetchgit, pkgconfig
, expat, gperf, bison, flex, openssl, perlPackages, coreutils, which
, libidn, spidermonkey_185, gtk2, makeWrapper, check, nspr, nettools
, libxml2, ui }:

stdenv.mkDerivation rec {

  name = "netsurf-${version}";
  version = "3.5";

  src = fetchgit {
    url = "http://git.netsurf-browser.org/netsurf-all.git";
    rev = "06c2a483a718573d3db65ae7b107772915c753bc";
    sha256 = "15hal3lj3lrs71aranl6rmp9xq45dv3mn3mwqk682xs7kf521f3h";
    fetchSubmodules = true;
  };

  buildInputs = [ SDL perl curl libpng pkgconfig expat gperf bison flex
    openssl libjpeg perlPackages.HTMLParser coreutils which libidn gtk2
    makeWrapper check nspr nettools libxml2 ];

  preConfigure = ''
    export PKG_CONFIG_PATH=$out/lib/pkgconfig:$PKG_CONFIG_PATH
    ( echo NETSURF_USE_DUKTAPE := NO;
      echo override NETSURF_GTK_RESOURCES := $out/share/res;
    # Disable experimental Javascript.
      echo override NETSURF_USE_MOZJS := NO )> netsurf/Makefile.config
  '';

  buildPhase = ''
    # ui can be any of : gtk framebuffer.
    # framebuffer can use sdl, but is buggy currently.
    export TARGET=${ui}
    export PREFIX=$out
    export PATH=$out/bin:$PATH
    for i in buildsystem \
      nsgenbind \
      libnsfb libwapcaplet libparserutils libcss libhubbub libdom \
      libnsbmp libnsgif librosprite libnsutils libutf8proc
    do
      (cd $i && make install )
    done
    # the actual browser
    (cd netsurf && make)
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share
    case "${ui}" in
      framebuffer) cp netsurf/nsfb $out/bin/netsurf ;;
      gtk) cp netsurf/nsgtk $out/bin/netsurf ;;
    esac
    cp -r netsurf/$TARGET/res $out/share
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "Free opensource web browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
