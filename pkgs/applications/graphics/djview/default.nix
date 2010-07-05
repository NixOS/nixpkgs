{stdenv, fetchurl, djvulibre, qt4 }:

stdenv.mkDerivation {
	name = "djview4-4.1-2";
	src = fetchurl {
		url = mirror://sf/djvu/djview4-4.1-2.tar.gz;
		sha256 = "10k0h892kab3n8xypw6vsnvhwil410hvvqj375pwiss4vlm5isv1";
	};

	buildInputs = [djvulibre qt4];

	meta = {
		homepage = http://djvu.sourceforge.net/djview4.html;
		description = "A new portable DjVu viewer and browser plugin";
		license = "GPL2";
    inherit (qt4.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
	};
}
