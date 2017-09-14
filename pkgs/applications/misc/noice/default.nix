{ stdenv, fetchgit, ncurses, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "noice-${version}";
  version = "0.6";

  src = fetchgit {
    url = "git://git.2f30.org/noice.git";
    rev = "refs/tags/v${version}";
    sha256 = "03rwglcy47fh6rb630vws10m95bxpcfv47nxrlws2li2ljam8prw";
  };

  configFile = optionalString (conf!=null) (builtins.toFile "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  buildInputs = [ ncurses ];

  buildFlags = [ "LDLIBS=-lncurses" ];

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = {
    description = "Small ncurses-based file browser";
    homepage = https://git.2f30.org/noice/;
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
