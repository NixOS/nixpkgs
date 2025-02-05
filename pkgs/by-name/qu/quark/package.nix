{
  lib,
  stdenv,
  fetchgit,
  patches ? null,
}:

stdenv.mkDerivation {
  pname = "quark";
  version = "unstable-2021-02-22";

  src = fetchgit {
    url = "git://git.suckless.org/quark";
    rev = "68b4f733b2755762e43df90f73db5a6ec8d14104";
    sha256 = "sha256-Jtu5zJfHd+6Oq572nVem5msMDCOjdqDNH4SQck8/O5A=";
  };

  inherit patches;

  makeFlags = [ "CC:=$(CC)" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Extremely small and simple HTTP GET/HEAD-only web server for static content";
    mainProgram = "quark";
    homepage = "http://tools.suckless.org/quark";
    license = licenses.isc;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}
