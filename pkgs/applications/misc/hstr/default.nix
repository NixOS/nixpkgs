{ stdenv, fetchurl, readline, ncurses }:

stdenv.mkDerivation rec {
  name    = "hstr-${version}";
  version = "1.24";

  src = fetchurl {
    url = "https://github.com/dvorka/hstr/releases/download/${version}/hh-${version}-src.tgz";
    sha256 = "0w8is777fwq6r17zhl9xwrv9f7vanllzjiasx1pg6pxvppq7rh0x";
  };

  buildInputs = [ readline ncurses ];

  meta = {
    homepage = https://github.com/dvorka/hstr;
    description = "Shell history suggest box - easily view, navigate, search and use your command history";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = with stdenv.lib.platforms; linux; # Cannot test others
  };

}
