{ stdenv, fetchFromGitHub, cmake, qtbase }:

stdenv.mkDerivation rec {
  name = "qgit-2.8";

  src = fetchFromGitHub {
    owner = "tibirna";
    repo = "qgit";
    rev = name;
    sha256 = "01l6mz2f333x3zbfr68mizwpsh6sdsnadcavpasidiych1m5ry8f";
  };

  buildInputs = [ qtbase ];

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    license = licenses.gpl2;
    homepage = http://libre.tibirna.org/projects/qgit/wiki/QGit;
    description = "Graphical front-end to Git";
    maintainers = with maintainers; [ peterhoeg markuskowa ];
    inherit (qtbase.meta) platforms;
  };
}
