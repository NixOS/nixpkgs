{stdenv, fetchurl, libX11, inputproto, libXt, libXpm, libXft, fontconfig,
	libXtst, xextproto, readline}:
stdenv.mkDerivation {
  name = "ratpoison-1.4.3";

  src = fetchurl {
    url = http://download.savannah.gnu.org/releases/ratpoison/ratpoison-1.4.3.tar.gz;
    sha256 = "15y3hi4dc7f98mhhpms22ahmh8lbzhyqli878z3fgrix4z7vr4fz";
  };

  buildInputs = [libX11 inputproto libXt
	 libXpm libXft fontconfig libXtst
	xextproto readline];
}
