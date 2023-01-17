{ lib, stdenv, fetchgit, ncurses, conf ? null }:

stdenv.mkDerivation rec {
  pname = "noice";
  version = "0.8";

  src = fetchgit {
    url = "git://git.2f30.org/noice.git";
    rev = "refs/tags/v${version}";
    sha256 = "0975j4m93s9a21pazwdzn4gqhkngwq7q6ghp0q8a75r6c4fb7aar";
  };

  postPatch = ''
    # Add support for ncurses-6.3. Can be dropped with 0.9 release.
    # Fixed upstream at: https://git.2f30.org/noice/commit/53c35e6b340b7c135038e00057a198f03cb7d7cf.html
    substituteInPlace noice.c --replace 'printw(str);' 'printw("%s", str);'
  '';

  configFile = lib.optionalString (conf!=null) (builtins.toFile "config.def.h" conf);
  preBuild = lib.optionalString (conf!=null) "cp ${configFile} config.def.h";

  buildInputs = [ ncurses ];

  buildFlags = [ "LDLIBS=-lncurses" ];

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = with lib; {
    description = "Small ncurses-based file browser";
    homepage = "https://git.2f30.org/noice/";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
