{ stdenv, fetchurl, clisp }:

let
    name    = "maxima";
    version = "5.21.1";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.gz";
    sha256 = "1dae887e1787871437d699a6b1acc1c1f7428729487492a07c6a31e26bf53a1b";
  };

  buildInputs = [clisp];

  meta = {
    description = "Maxima computer algebra system";
    homepage = http://maxima.sourceforge.net;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
