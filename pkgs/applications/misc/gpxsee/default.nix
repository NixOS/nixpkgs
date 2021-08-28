{ lib, stdenv, mkDerivation, fetchFromGitHub, qmake, qttools, qttranslations, substituteAll }:

mkDerivation rec {
  pname = "gpxsee";
  version = "9.0";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "sha256-4MzRXpxvJcj5KptTBH6rSr2ZyQ13nV7Yq96ti+CMytw=";
  };

  patches = (substituteAll {
    # See https://github.com/NixOS/nixpkgs/issues/86054
    src = ./fix-qttranslations-path.diff;
    inherit qttranslations;
  });

  nativeBuildInputs = [ qmake qttools ];

  preConfigure = ''
    lrelease gpxsee.pro
  '';

  postInstall = with stdenv; lib.optionalString isDarwin ''
    mkdir -p $out/Applications
    mv GPXSee.app $out/Applications
    wrapQtApp $out/Applications/GPXSee.app/Contents/MacOS/GPXSee
  '';

  meta = with lib; {
    description = "GPS log file viewer and analyzer";
    longDescription = ''
      GPXSee is a Qt-based GPS log file viewer and analyzer that supports
      all common GPS log file formats.
    '';
    homepage = "https://www.gpxsee.org/";
    changelog = "https://build.opensuse.org/package/view_file/home:tumic:GPXSee/gpxsee/gpxsee.changes";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ womfoo sikmir ];
    platforms = with platforms; linux ++ darwin;
  };
}
