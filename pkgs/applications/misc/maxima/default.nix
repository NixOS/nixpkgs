args: with args;
stdenv.mkDerivation {
  name = "maxima-5.13.0";

  src =	fetchurl {
		name = "maxima-5.13.0.tar.gz";
		url = mirror://sf/maxima/maxima-5.13.0.tar.gz;
		sha256 = "11zidbbp4cbgsmdfyf9w0j7345ydka469ba0my7p73zqhnby09cn";
	};

  buildInputs =[clisp];

  meta = {
    description = "Maxima computer algebra system";
    homepage = http://maxima.sourceforge.net;
  };
}
