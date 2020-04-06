{ stdenv, fetchFromGitHub, cmake, gettext, perl, asciidoc
, libjpeg, libtiff, libungif, libpng, imlib, expat
, freetype, fontconfig, pkgconfig, gdk-pixbuf
, mkfontdir, libX11, libXft, libXext, libXinerama
, libXrandr, libICE, libSM, libXpm, libXdmcp, libxcb
, libpthreadstubs, pcre, libXdamage, libXcomposite, libXfixes
, libsndfile, fribidi }:

stdenv.mkDerivation rec {
  pname = "icewm";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner  = "bbidulock";
    repo   = "icewm";
    rev    = version;
    sha256 = "1glzpkpl0vl5sjn1d9jlvwd9ch16dvxvsf2n310kb0ycpfkl84vs";
  };

  nativeBuildInputs = [ cmake pkgconfig perl asciidoc ];

  buildInputs = [
    gettext libjpeg libtiff libungif libpng imlib expat
    freetype fontconfig gdk-pixbuf mkfontdir libX11
    libXft libXext libXinerama libXrandr libICE libSM libXpm
    libXdmcp libxcb libpthreadstubs pcre libsndfile fribidi
    libXdamage libXcomposite libXfixes
  ];

  cmakeFlags = [ "-DPREFIX=$out" "-DCFGDIR=/etc/icewm" ];

  # install legacy themes
  postInstall = ''
    cp -r ../lib/themes/{gtk2,Natural,nice,nice2,warp3,warp4,yellowmotif} $out/share/icewm/themes/
  '';

  meta = with stdenv.lib; {
    description = "A simple, lightweight X window manager";
    longDescription = ''
      IceWM is a window manager for the X Window System. The goal of
      IceWM is speed, simplicity, and not getting in the user's way.
    '';
    homepage = "http://www.icewm.org/";
    license = licenses.lgpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
