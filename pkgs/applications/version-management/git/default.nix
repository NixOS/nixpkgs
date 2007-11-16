args: with args;

stdenv.mkDerivation rec {
  name = "git-1.5.3.5";

  src = fetchurl {
    url = "mirror://kernel/software/scm/git/${name}.tar.bz2";
    sha256 = "0ab63s25wzmsl5inp7bykz5ac7xjilqa0ciaz7ydhciymz6gkawj";
  };

  buildInputs = [curl openssl zlib expat];

  makeFlags="prefix=\${out} PERL_PATH=${perl}/bin/perl SHELL_PATH=${stdenv.shell}";

  meta = {
	  license = "GPL2";
	  homepage = http://git.or.cz;
	  description = "A popular version control system designed to handle very
	  large projects with speed and efficiency";
  };
}
