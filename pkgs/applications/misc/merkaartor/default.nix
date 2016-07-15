{ stdenv, fetchFromGitHub, qt4, qmake4Hook, boost, proj, gdal, sqlite, pkgconfig }:

stdenv.mkDerivation rec {
  name = "merkaartor-${version}";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "merkaartor";
    rev = version;
    sha256 = "1a8kzrc9w0b2a2zgw9dbbi15jy9ynv6nf2sg3k4dbh7f1s2ajx9l";
  };

  buildInputs = [ qt4 boost proj gdal sqlite ];

  nativeBuildInputs = [ qmake4Hook pkgconfig ];

  meta = {
    description = "An openstreetmap editor";
    homepage = http://merkaartor.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric urkud];
    inherit (qt4.meta) platforms;
  };
}
