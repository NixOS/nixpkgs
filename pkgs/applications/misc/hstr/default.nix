{ stdenv, fetchurl, readline, ncurses }:

let
  version = "1.16";
in
stdenv.mkDerivation rec {

  name = "hstr-${version}";

  src = fetchurl {
    url = "https://github.com/dvorka/hstr/releases/download/${version}/hh-${version}-src.tgz";
    sha256 = "1hl3fn6kravx5gsdsr0l824vnkj5aiz0dybhd3ak932v95b5knyg";
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
