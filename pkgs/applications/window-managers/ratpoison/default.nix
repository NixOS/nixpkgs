{stdenv, fetchurl, libX11, inputproto, libXt, libXpm, libXft, fontconfig,
	libXtst, xextproto, readline}:
stdenv.mkDerivation {
  name = "RatPoison-1.4.1";

  src = fetchurl {
    url = http://download.savannah.gnu.org/releases/ratpoison/ratpoison-1.4.1.tar.gz;
    md5 = "fcbdcc84cfad9b18518074f676eba270";
  };

  buildInputs = [libX11 inputproto libXt
	 libXpm libXft fontconfig libXtst 
	xextproto readline];
}
