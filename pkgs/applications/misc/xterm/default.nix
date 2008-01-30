{stdenv, fetchurl, libXaw, xproto, libXt, libX11, libSM, libICE, ncurses}:

stdenv.mkDerivation rec {
  name = "xterm-231";
  src = fetchurl {
    url = "ftp://invisible-island.net/xterm/${name}.tgz";
    sha256 = "0qlz5nkdqkahdg9kbd1ni96n69srj1pd9yggwrw3z0kghaajb2sr";
  };
  buildInputs = [libXaw xproto libXt libX11 libSM libICE ncurses];
  configureFlags = ["--enable-wide-chars"];

  meta = {
    homepage = http://invisible-island.net/xterm;
  };
}

