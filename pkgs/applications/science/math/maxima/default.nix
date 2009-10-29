{ stdenv, fetchurl, clisp }:

let
    name    = "maxima";
    version = "5.19.2";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.gz";
    sha256 = "4b9d592cb5c5b49acf10c894aa4e899bd47f079b315ee22542122a2e64589072";
  };

  buildInputs = [clisp];

  meta = {
    description = "Maxima computer algebra system";
    homepage = http://maxima.sourceforge.net;
  };
}
