{ stdenv, fetchFromGitHub, qmake, qttools, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "gpxsee";
  version = "7.9";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "029l5dhc9nnxiw7p0s4gyfkcqw709z7lz96aq8krs75mfk4fv07k";
  };

  nativeBuildInputs = [ qmake makeWrapper ];
  buildInputs = [ qttools ];

  preConfigure = ''
    lrelease lang/*.ts
  '';

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/gpxsee \
      --prefix XDG_DATA_DIRS ":" $out/share
  '';

  meta = with stdenv.lib; {
    homepage = https://www.gpxsee.org/;
    description = "GPS log file viewer and analyzer";
    longDescription = ''
      GPXSee is a Qt-based GPS log file viewer and analyzer that supports
      all common GPS log file formats.
    '';
    license = licenses.gpl3;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };
}
