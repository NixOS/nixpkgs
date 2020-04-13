{ stdenv, fetchgit, ncurses, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "noice";
  version = "0.8";

  src = fetchgit {
    url = "git://git.2f30.org/noice.git";
    rev = "refs/tags/v${version}";
    sha256 = "0975j4m93s9a21pazwdzn4gqhkngwq7q6ghp0q8a75r6c4fb7aar";
  };

  configFile = optionalString (conf!=null) (builtins.toFile "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  buildInputs = [ ncurses ];

  buildFlags = [ "LDLIBS=-lncurses" ];

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = {
    description = "Small ncurses-based file browser";
    homepage = "https://git.2f30.org/noice/";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
