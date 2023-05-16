{ lib, stdenv
, fetchurl
, ncurses
, readline
}:

stdenv.mkDerivation rec {
  pname = "ytree";
<<<<<<< HEAD
  version = "2.05";

  src = fetchurl {
    url = "https://han.de/~werner/${pname}-${version}.tar.gz";
    sha256 = "sha256-jPixUeSRO1t/epHf/VxzBhBqQkd+xE5x1ix19mq2Glc=";
=======
  version = "2.04";

  src = fetchurl {
    url = "https://han.de/~werner/${pname}-${version}.tar.gz";
    sha256 = "sha256-bnqLf2jv5tNlq+M6HQbXOa2F8io9VN3QrsJKNHjWZkI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    ncurses
    readline
  ];

  # don't save timestamp, in order to improve reproducibility
  postPatch = ''
    substituteInPlace Makefile --replace 'gzip' 'gzip -n'
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = with lib; {
    description = "A curses-based file manager similar to DOS Xtree(TM)";
    homepage = "https://www.han.de/~werner/ytree.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
# TODO: X11 support
