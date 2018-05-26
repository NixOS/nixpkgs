{ stdenv, fetchgit, cmake, qtbase }:

stdenv.mkDerivation rec {
  name = "qgit-2.7";

  src = fetchgit {
    url = "http://repo.or.cz/qgit4/redivivus.git";
    rev = name;
    sha256 = "0c0zxykpgkxb8gpgzz5i6b8nrzg7cdxikvpg678x7gsnxhlwjv3a";
  };

  buildInputs = [ qtbase ];

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    license = licenses.gpl2;
    homepage = http://libre.tibirna.org/projects/qgit/wiki/QGit;
    description = "Graphical front-end to Git";
    maintainers = with maintainers; [ peterhoeg ];
    inherit (qtbase.meta) platforms;
  };
}
