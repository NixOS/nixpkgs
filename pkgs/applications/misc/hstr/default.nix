{ stdenv, fetchurl, readline, ncurses }:

let
  version = "1.17";
in
stdenv.mkDerivation rec {

  name = "hstr-${version}";

  src = fetchurl {
    url = "https://github.com/dvorka/hstr/releases/download/${version}/hh-${version}-src.tgz";
    sha256 = "0vjc4d8cl3sfbv9lywdpd2slffqyp3cpj52yp29g9lr2n3nfksk8";
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
