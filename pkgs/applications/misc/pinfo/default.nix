{stdenv, fetchurl, ncurses, readline}:

stdenv.mkDerivation {
  name = "pinfo-0.6.9";
  src = fetchurl {
    url = https://alioth.debian.org/frs/download.php/1498/pinfo-0.6.9.tar.bz2;
    sha256 = "1rbsz1y7nyz6ax9xfkw5wk6pnrhvwz2xcm0wnfnk4sb2wwq760q3";
  };
  buildInputs = [ncurses readline];

  configureFlags = "--with-curses=${ncurses} --with-readline=${readline}";
}
