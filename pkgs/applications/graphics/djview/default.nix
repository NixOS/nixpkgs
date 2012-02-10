{stdenv, fetchurl, djvulibre, qt4, pkgconfig }:

stdenv.mkDerivation rec {
	name = "djview-4.8";
	src = fetchurl {
		url = "mirror://sourceforge/djvu/${name}.tar.gz";
		sha256 = "17y8jvbvj98h25qwsr93v24x75famv8d0jbb0h46xjj555y6wx4c";
	};

	buildInputs = [djvulibre qt4];

  buildNativeInputs = [ pkgconfig ];

  patches = [ ./djview4-qt-4.8.patch ];

  passthru = {
    mozillaPlugin = "/lib/netscape/plugins";
  };

	meta = {
		homepage = http://djvu.sourceforge.net/djview4.html;
		description = "A new portable DjVu viewer and browser plugin";
		license = "GPL2";
    inherit (qt4.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
	};
}
