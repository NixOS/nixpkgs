{ stdenv, fetchFromGitHub, pkgconfig, ncurses, readline, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "nnn-${version}";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "nnn";
    rev = "v${version}";
    sha256 = "03cgsdj4l19gla5fx9d1ydqirpsah9d7gx9jaik73x38zqsabr89";
  };

  configFile = optionalString (conf!=null) (builtins.toFile "nnn.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} nnn.h";

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
