args: with args;

stdenv.mkDerivation rec {
  name = "git-1.5.4.1";

  src = fetchurl {
    url = "mirror://kernel/software/scm/git/${name}.tar.bz2";
    sha256 = "17abc4de0cd46a15ecdd90dfb28edfbaafcd0f0ce7a081c1c4dfae9b2f5b217f";
  };

  buildInputs = [curl openssl zlib expat gettext];

  makeFlags="prefix=\${out} PERL_PATH=${perl}/bin/perl SHELL_PATH=${stdenv.shell}";

  meta = {
	  license = "GPL2";
	  homepage = http://git.or.cz;
	  description = "A popular version control system designed to handle very
	  large projects with speed and efficiency";
  };
}
