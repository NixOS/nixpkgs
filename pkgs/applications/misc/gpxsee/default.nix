{ stdenv, mkDerivation, fetchFromGitHub, qmake, qttools, qttranslations }:

mkDerivation rec {
  pname = "gpxsee";
  version = "7.31";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "0y60h66p8ydkinxk9x4sp4cm6gq66nc9jcavy135vmycsiq9gphn";
  };

  patches = [
    # See https://github.com/NixOS/nixpkgs/issues/86054
    ./fix-qttranslations-path.diff
  ];

  nativeBuildInputs = [ qmake qttools ];

  postPatch = ''
    substituteInPlace src/GUI/app.cpp \
      --subst-var-by qttranslations ${qttranslations}
  '';

  preConfigure = ''
    lrelease gpxsee.pro
  '';

  postInstall = with stdenv; lib.optionalString isDarwin ''
    mkdir -p $out/Applications
    mv GPXSee.app $out/Applications
    wrapQtApp $out/Applications/GPXSee.app/Contents/MacOS/GPXSee
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://www.gpxsee.org/";
    description = "GPS log file viewer and analyzer";
    longDescription = ''
      GPXSee is a Qt-based GPS log file viewer and analyzer that supports
      all common GPS log file formats.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ womfoo sikmir ];
    platforms = with platforms; linux ++ darwin;
  };
}
