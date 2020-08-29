{ stdenv, fetchurl, fetchpatch, makeWrapper, wrapGAppsHook

# Buildtime dependencies.

, check, pkgconfig, xxd

# Runtime dependencies.

, curl, expat, libXcursor, libXrandr, libidn, libjpeg, libpng, libwebp, libxml2
, openssl, perl, perlPackages

# uilib-specific dependencies

, gtk3 # GTK 3
, gtk2 # GTK 2
, SDL  # Framebuffer

# Configuration

, uilib ? "framebuffer"

# Netsurf-specific dependencies

, libcss, libdom, libhubbub, libnsbmp, libnsfb, libnsgif
, libnslog, libnspsl, libnsutils, libparserutils, libsvgtiny, libutf8proc
, libwapcaplet, nsgenbind
}:

let
  inherit (stdenv.lib) optional optionals;
in
stdenv.mkDerivation rec {

  pname = "netsurf";
  version = "3.10";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/netsurf/releases/source/netsurf-${version}-src.tar.gz";
    sha256 = "0plra64c5xyiw12yx2q13brxsv8apmany97zqa2lcqckw4ll8j1n";
  };

  nativeBuildInputs = [
    makeWrapper
    perl
    perlPackages.HTMLParser
    pkgconfig
    xxd
  ]
  ++ optional (uilib == "gtk3" || uilib == "gtk2") wrapGAppsHook
  ;

  buildInputs = [ 
    check curl libXcursor libXrandr libidn libjpeg libpng libwebp libxml2 openssl
    # Netsurf-specific libraries
    nsgenbind libnsfb libwapcaplet libparserutils libnslog libcss
    libhubbub libdom libnsbmp libnsgif libsvgtiny libnsutils libnspsl
    libutf8proc
  ]
  ++ optionals (uilib == "framebuffer") [ expat SDL ]
  ++ optional (uilib == "gtk3") gtk3
  ++ optional (uilib == "gtk2") gtk2
  ;

  patches = [ ./0001-Fix-GTK-2-icons-since-commit-11aa6821.patch ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "TARGET=${uilib}"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.netsurf-browser.org/";
    description = "Free opensource web browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
