{ stdenv, fetchurl, readline, ncurses }:

stdenv.mkDerivation rec {
  name    = "hstr-${version}";
  version = "1.25";

  src = fetchurl {
    url = "https://github.com/dvorka/hstr/releases/download/${version}/hh-${version}-src.tgz";
    sha256 = "10njj0a3s5czv497wk3whka3gxr7vmhabs12vaw7kgb07h4ssnhg";
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
