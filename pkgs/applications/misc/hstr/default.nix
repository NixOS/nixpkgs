{ stdenv, fetchurl, readline, ncurses }:

let
  version = "1.22";
in
stdenv.mkDerivation rec {

  name = "hstr-${version}";

  src = fetchurl {
    url = "https://github.com/dvorka/hstr/releases/download/${version}/hh-${version}-src.tgz";
    sha256 = "09rh510x8qc5jbpnfzazbv9wc3bqmf5asydcl2wijpqm5bi21iqp";
  };

  buildInputs = [ readline ncurses ];

  meta = {
    homepage = https://github.com/dvorka/hstr;
    description = "Shell history suggest box - easily view, navigate, search and use your command history";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux; # Cannot test others
  };

}
