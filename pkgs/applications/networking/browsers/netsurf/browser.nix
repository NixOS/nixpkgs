{ lib, stdenv, fetchurl, makeWrapper, wrapGAppsHook

# Buildtime dependencies.
, check, pkg-config, xxd

# Runtime dependencies.
, curl, expat, libXcursor, libXrandr, libidn, libjpeg, libpng, libwebp, libxml2
, openssl, perl, perlPackages

# uilib-specific dependencies
, gtk2 # GTK 2
, gtk3 # GTK 3
, SDL  # Framebuffer

# Configuration
, uilib

# Netsurf-specific dependencies
, libcss, libdom, libhubbub, libnsbmp, libnsfb, libnsgif
, libnslog, libnspsl, libnsutils, libparserutils, libsvgtiny, libutf8proc
, libwapcaplet, nsgenbind
}:

let
  inherit (lib) optional optionals;
in
stdenv.mkDerivation rec {
  pname = "netsurf";
  version = "3.10";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/netsurf/releases/source/${pname}-${version}-src.tar.gz";
    sha256 = "sha256-NkhEKeGTYUaFwv8kb1W9Cm3d8xoBi+5F4NH3wohRmV4=";
  };

  nativeBuildInputs = [
    makeWrapper
    perl
    perlPackages.HTMLParser
    pkg-config
    xxd
  ]
  ++ optional (uilib == "gtk2" || uilib == "gtk3") wrapGAppsHook
  ;

  buildInputs = [
    check curl libXcursor libXrandr libidn libjpeg libpng libwebp libxml2 openssl
    # Netsurf-specific libraries
    nsgenbind libnsfb libwapcaplet libparserutils libnslog libcss
    libhubbub libdom libnsbmp libnsgif libsvgtiny libnsutils libnspsl
    libutf8proc
  ]
  ++ optionals (uilib == "framebuffer") [ expat SDL ]
  ++ optional (uilib == "gtk2") gtk2
  ++ optional (uilib == "gtk3") gtk3
  ;

  preConfigure = ''
    cat <<EOF > Makefile.conf
    override NETSURF_GTK_RES_PATH  := $out/share/
    override NETSURF_USE_GRESOURCE := YES
    EOF
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "TARGET=${uilib}"
  ];

  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/";
    description = "A free, open source, small web browser";
    longDescription = ''
      NetSurf is a free, open source web browser. It is written in C and
      released under the GNU Public Licence version 2. NetSurf has its own
      layout and rendering engine entirely written from scratch. It is small and
      capable of handling many of the web standards in use today.
    '';
    license = licenses.gpl2Only;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
