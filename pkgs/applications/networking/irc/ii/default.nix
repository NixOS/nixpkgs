{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "ii";
  version = "1.9";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/${pname}-${version}.tar.gz";
    sha256 = "sha256-hQyzI7WD0mG1G9qZk+5zMzQ1Ko5soeLwK1fBVL9WjBc=";
  };

  makeFlags = [ "CC:=$(CC)" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://tools.suckless.org/ii/";
    license = lib.licenses.mit;
    description = "Irc it, simple FIFO based irc client";
    platforms = lib.platforms.unix;
  };
}
