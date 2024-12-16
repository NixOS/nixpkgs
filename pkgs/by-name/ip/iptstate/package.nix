{
  lib,
  stdenv,
  fetchurl,
  libnetfilter_conntrack,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "iptstate";
  version = "2.2.7";

  src = fetchurl {
    url = "https://github.com/jaymzh/iptstate/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-iW3wYCiFRWomMfeV1jT8ITEeUF+MkQNI5jEoYPIJeVU=";
  };

  buildInputs = [
    libnetfilter_conntrack
    ncurses
  ];

  meta = with lib; {
    description = "Conntrack top like tool";
    mainProgram = "iptstate";
    homepage = "https://github.com/jaymzh/iptstate";
    platforms = platforms.linux;
    maintainers = with maintainers; [ trevorj ];
    downloadPage = "https://github.com/jaymzh/iptstate/releases";
    license = licenses.zlib;
  };

  installPhase = ''
    install -m755 -D iptstate $out/bin/iptstate
  '';
}
