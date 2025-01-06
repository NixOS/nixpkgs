{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "n2048";
  version = "0.1";
  src = fetchurl {
    url = "http://www.dettus.net/n2048/n2048_v${version}.tar.gz";
    sha256 = "184z2rr0rnj4p740qb4mzqr6kgd76ynb5gw9bj8hrfshcxdcg1kk";
  };
  buildInputs = [
    ncurses
  ];
  makeFlags = [
    "DESTDIR=$(out)"
  ];
  preInstall = ''
    mkdir -p "$out"/{share/man,bin}
  '';
  meta = {
    description = "Console implementation of 2048 game";
    mainProgram = "n2048";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    homepage = "http://www.dettus.net/n2048/";
  };
}
