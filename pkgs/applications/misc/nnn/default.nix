{ stdenv, fetchFromGitHub, pkgconfig, ncurses, readline, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "nnn-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "nnn";
    rev = "v${version}";
    sha256 = "0w9i9vwyqgsi64b5mk4rhmr5gvnnb24c98321r0j5hb0ghdcp96s";
  };

  configFile = optionalString (conf!=null) (builtins.toFile "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses readline ];

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = {
    description = "Small ncurses-based file browser forked from noice";
    homepage = https://github.com/jarun/nnn;
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
