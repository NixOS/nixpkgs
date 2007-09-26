args: with args;
stdenv.mkDerivation {
  name = "maxima-5.13.0";

  src =	fetchurl {
		name = "maxima-5.13.0.tar.gz";
		url = http://downloads.sourceforge.net/maxima/maxima-5.13.0.tar.gz?modtime=1188046120&big_mirror=1;
		sha256 = "11zidbbp4cbgsmdfyf9w0j7345ydka469ba0my7p73zqhnby09cn";
	};

  buildInputs =[clisp];

  meta = {
    description = "
	Maxima computer algebra system
";
  };
}
