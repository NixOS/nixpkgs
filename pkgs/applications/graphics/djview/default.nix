{ stdenv, fetchurl, pkgconfig
, djvulibre, qt4, xorg, libtiff
, darwin }:

stdenv.mkDerivation rec {
  name = "djview-${version}";
  version = "4.10.6";

  src = fetchurl {
    url = "mirror://sourceforge/djvu/${name}.tar.gz";
    sha256 = "08bwv8ppdzhryfcnifgzgdilb12jcnivl4ig6hd44f12d76z6il4";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ djvulibre qt4 xorg.libXt libtiff ]
  ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AGL ];

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  meta = with stdenv.lib; {
    homepage = http://djvu.sourceforge.net/djview4.html;
    description = "A portable DjVu viewer and browser plugin";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
