{ stdenv, fetchurl, readline, ncurses }:

let
  version = "1.19";
in
stdenv.mkDerivation rec {

  name = "hstr-${version}";

  src = fetchurl {
    url = "https://github.com/dvorka/hstr/releases/download/${version}/hh-${version}-src.tgz";
    sha256 = "0ix6550l9si29j8vz375vzjmp22i19ik5dq2nh7zsj2ra7ibaz5n";
  };

  buildInputs = [ readline ncurses ];

  meta = {
    homepage = "https://github.com/dvorka/hstr";
    description = "Shell history suggest box - easily view, navigate, search and use your command history";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux; # Cannot test others
  };

}
