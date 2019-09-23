{ stdenv, fetchurl, fetchpatch, makeWrapper, wrapGAppsHook

# Buildtime dependencies.

, check, pkgconfig, xxd

# Runtime dependencies.

, curl, expat, libXcursor, libXrandr, libidn, libjpeg, libpng, libwebp, libxml2
, openssl, perl, perlPackages

# uilib-specific dependencies

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
  version = "3.9";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/netsurf/releases/source/netsurf-${version}-src.tar.gz";
    sha256 = "1hzcm2s2wh5sapgr000lg63hcdbj6hyajxl43xa1x80kc5piqbyp";
  };

  patches = [
    # GTK: prefer using curl's intrinsic defaults for CURLOPT_CA*
    (fetchpatch {
	  name = "0001-GTK-prefer-using-curl-s-intrinsic-defaults-for-CURLO.patch";
      url = "http://source.netsurf-browser.org/netsurf.git/patch/?id=87177d8aa109206d131e0d80a2080ce55dab01c7";
      sha256 = "08bc60pc5k5qpckqv21zgmgszj3rpwskfc84shs8vg92vkimv2ai";
    })
  ];

  nativeBuildInputs = [
    makeWrapper
    perl
    perlPackages.HTMLParser
    pkgconfig
    xxd
  ]
  ++ optional (uilib == "gtk") wrapGAppsHook
  ;

  buildInputs = [ 
    check curl libXcursor libXrandr libidn libjpeg libpng libwebp libxml2 openssl
    # Netsurf-specific libraries
    nsgenbind libnsfb libwapcaplet libparserutils libnslog libcss
    libhubbub libdom libnsbmp libnsgif libsvgtiny libnsutils libnspsl
    libutf8proc
  ]
  ++ optionals (uilib == "framebuffer") [ expat SDL ]
  ++ optional (uilib == "gtk") gtk2
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

  meta = with stdenv.lib; {
    homepage = http://www.netsurf-browser.org/;
    description = "Free opensource web browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
