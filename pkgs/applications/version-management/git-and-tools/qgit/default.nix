{ stdenv, fetchurl, cmake, qtbase }:

stdenv.mkDerivation rec {
  name = "qgit-2.6";

  src = fetchurl {
    url = "http://libre.tibirna.org/attachments/download/12/${name}.tar.gz";
    sha256 = "1brrhac6s6jrw3djhgailg5d5s0vgrfvr0sczqgzpp3i6pxf8qzl";
  };

  buildInputs = [ qtbase ];

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    license = licenses.gpl2;
    homepage = http://libre.tibirna.org/projects/qgit/wiki/QGit;
    description = "Graphical front-end to Git";
    maintainers = with maintainers; [ peterhoeg ];
    inherit (qtbase.meta) platforms;
  };
}
