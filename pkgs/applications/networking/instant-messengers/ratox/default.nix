{ stdenv, fetchgit, libtoxcore
, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "ratox-dev-20150107";

  src = fetchgit {
    url = "git://git.2f30.org/ratox";
    rev = "8be76e4cc829d86b8e1cae43a0d932600d6ff9fb";
    sha256 = "7fe492de3e69a08f9c1bb59a319d0e410905f06514abe99b4d4fe5c899650448";
  };

  buildInputs = [ libtoxcore ];

  configFile = optionalString (conf!=null) (builtins.toFile "config.h" conf);
  preConfigure = optionalString (conf!=null) "cp ${configFile} config.def.h";

  preBuild = "makeFlags=PREFIX=$out";

  meta =
    { description = "FIFO based tox client";
      homepage = http://ratox.2f30.org/;
      license = licenses.isc;
      maintainers = with maintainers; [ emery ];
      platforms = platforms.linux;
    };
}
