{ stdenv, fetchurl, pkgconfig, libpng, openssl, curl, gtk2, check
, libxml2, libidn, perl, nettools, perlPackages
, libXcursor, libXrandr, makeWrapper
, buildsystem
, nsgenbind
, libnsfb
, libwapcaplet
, libparserutils
, libcss
, libhubbub
, libdom
, libnsbmp
, libnsgif
, libnsutils
, libutf8proc
}:

stdenv.mkDerivation rec {

  name = "netsurf-${version}";
  version = "3.5";

  # UIS incldue Framebuffer, and gtk, but
  # Framebuffer is buggy. To enable, make sure
  # to also build netsurf-libnsfb with ui=framebuffer
  # and switch the ui here to framebuffer
  ui = "gtk";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/netsurf/releases/source/netsurf-${version}-src.tar.gz";
    sha256 = "1k0x8mzgavfy7q9kywl6kzsc084g1xlymcnsxi5v6jp279nsdwwq";
  };

  buildInputs = [ pkgconfig libpng openssl curl gtk2 check libxml2 libidn perl
    nettools perlPackages.HTMLParser libXcursor libXrandr makeWrapper
    buildsystem
    nsgenbind
    libnsfb
    libwapcaplet
    libparserutils
    libcss
    libhubbub
    libdom
    libnsbmp
    libnsgif
    libnsutils
    libutf8proc
 ];

  preConfigure = ''
    cat <<EOF > Makefile.conf
    override NETSURF_GTK_RESOURCES := $out/share/Netsurf/${ui}/res
    override NETSURF_USE_GRESOURCE := YES
    EOF
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
    "TARGET=${ui}"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/Netsurf/${ui}
    cmd=$(case "${ui}" in framebuffer) echo nsfb;; gtk) echo nsgtk;; esac)
    cp $cmd $out/bin/netsurf
    wrapProgram $out/bin/netsurf --set NETSURFRES $out/share/Netsurf/${ui}/res
    tar -hcf - ${ui}/res | (cd $out/share/Netsurf/ && tar -xvpf -)
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "Free opensource web browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
