{ stdenv, fetchurl, gmp, zlib }:

stdenv.mkDerivation {
  version = "4.2.1";
  pname = "form";

  # This tarball is released by author, it is not downloaded from tag, so can't use fetchFromGitHub
  src = fetchurl {
    url = "https://github.com/vermaseren/form/releases/download/v4.2.1/form-4.2.1.tar.gz";
    sha256 = "0a0smc10gm85vxd85942n5azy88w5qs5avbqrw0lw0yb9injswpj";
  };

  buildInputs = [ gmp zlib ];

  meta = with stdenv.lib; {
    description = "The FORM project for symbolic manipulation of very big expressions";
    homepage = https://www.nikhef.nl/~form/;
    license = licenses.gpl3;
    maintainers = [ maintainers.veprbl ];
    platforms = platforms.unix;
  };
}
