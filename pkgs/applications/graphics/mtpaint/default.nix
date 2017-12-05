{ stdenv, fetchFromGitHub
, pkgconfig
, freetype, giflib, gtk2, lcms2, libjpeg, libpng, libtiff, openjpeg, gifsicle
}:

stdenv.mkDerivation rec {
  p_name  = "mtPaint";
  ver_maj = "3.49";
  ver_min = "12";
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchFromGitHub {
    owner = "wjaguar";
    repo = p_name;
    rev = "6aed1b0441f99055fc7d475942f8bd5cb23c41f8";
    sha256 = "0bvf623g0n2ifijcxv1nw0z3wbs2vhhdky4n04ywsbjlykm44nd1";
  };

  buildInputs = [
    pkgconfig
    freetype giflib gtk2 lcms2 libjpeg libpng libtiff openjpeg gifsicle
  ];

  meta = {
    description = "A simple GTK+1/2 painting program";
    longDescription = ''
      mtPaint is a simple GTK+1/2 painting program designed for
      creating icons and pixel based artwork.  It can edit indexed palette
      or 24 bit RGB images and offers basic painting and palette manipulation
      tools. It also has several other more powerful features such as channels,
      layers and animation.
      Due to its simplicity and lack of dependencies it runs well on
      GNU/Linux, Windows and older PC hardware.
    '';
    homepage = http://mtpaint.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.vklquevs ];
  };
}

