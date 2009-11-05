{stdenv, fetchurl, libX11, inputproto, libXt, libXpm, libXft, fontconfig,
	libXtst, xextproto, readline, libXi}:
stdenv.mkDerivation {
  name = "ratpoison-1.4.5";

  src = fetchurl {
    url = http://download.savannah.gnu.org/releases/ratpoison/ratpoison-1.4.5.tar.gz;
    sha256 = "7391079db20b8613eecfd81d64d243edc9d3c586750c8f2da2bb9db14d260f03";
  };

  buildInputs = [libX11 inputproto libXt
	 libXpm libXft fontconfig libXtst
	xextproto readline libXi];
}
