{ stdenv, fetchurl, clisp }:

let
    name    = "maxima";
    version = "5.20.1";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.gz";
    sha256 = "cc2430ad6b895fb730ee2a7b8df4852c2b6d09a5a8bb715bdba783982c470bd9";
  };

  buildInputs = [clisp];

  meta = {
    description = "Maxima computer algebra system";
    homepage = http://maxima.sourceforge.net;
  };
}
