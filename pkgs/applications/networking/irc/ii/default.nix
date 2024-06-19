{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "ii";
  version = "2.0";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/${pname}-${version}.tar.gz";
    sha256 = "sha256-T2evzSCMB5ObiKrb8hSXpwKtCgf5tabOhh+fOf/lQls=";
  };

  makeFlags = [ "CC:=$(CC)" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://tools.suckless.org/ii/";
    license = lib.licenses.mit;
    description = "Irc it, simple FIFO based irc client";
    mainProgram = "ii";
    platforms = lib.platforms.unix;
  };
}
