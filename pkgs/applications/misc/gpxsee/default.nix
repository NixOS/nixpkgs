{ lib
, stdenv
, fetchFromGitHub
, qmake
, nix-update-script
<<<<<<< HEAD
, qtbase
, qttools
, qtlocation ? null # qt5 only
, qtpositioning ? null # qt6 only
=======
, substituteAll
, qtbase
, qttools
, qttranslations
, qtlocation ? null # qt5 only
, qtpositioning ? null # qt6 only
, qtpbfimageplugin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, qtserialport
, qtsvg
, qt5compat ? null # qt6 only
, wrapQtAppsHook
}:

let
  isQt6 = lib.versions.major qtbase.version == "6";
<<<<<<< HEAD
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gpxsee";
  version = "13.7";
=======

in
stdenv.mkDerivation rec {
  pname = "gpxsee";
  version = "13.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
<<<<<<< HEAD
    rev = finalAttrs.version;
    hash = "sha256-Y3JcWkg0K724i/5Leyi8r26uKpq/aDwghJBG8xfxpd4=";
  };

  buildInputs = [
    qtserialport
  ] ++ (if isQt6 then [
=======
    rev = version;
    hash = "sha256-3s+LPD4KcnSWrg4JHPcbUjilwztjX8lAdQpx0h4dH0Y=";
  };

  patches = (substituteAll {
    # See https://github.com/NixOS/nixpkgs/issues/86054
    src = ./fix-qttranslations-path.diff;
    inherit qttranslations;
  });

  buildInputs = [ qtpbfimageplugin qtserialport ]
    ++ (if isQt6 then [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    qtbase
    qtpositioning
    qtsvg
    qt5compat
  ] else [
    qtlocation
  ]);

<<<<<<< HEAD
  nativeBuildInputs = [
    qmake
    qttools
    wrapQtAppsHook
  ];
=======
  nativeBuildInputs = [ qmake qttools wrapQtAppsHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preConfigure = ''
    lrelease gpxsee.pro
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv GPXSee.app $out/Applications
    mkdir -p $out/bin
    ln -s $out/Applications/GPXSee.app/Contents/MacOS/GPXSee $out/bin/gpxsee
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

<<<<<<< HEAD
  meta = {
    broken = isQt6 && stdenv.isDarwin;
    changelog = "https://build.opensuse.org/package/view_file/home:tumic:GPXSee/gpxsee/gpxsee.changes";
    description = "GPS log file viewer and analyzer";
    homepage = "https://www.gpxsee.org/";
    license = lib.licenses.gpl3Only;
=======
  meta = with lib; {
    description = "GPS log file viewer and analyzer";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      GPXSee is a Qt-based GPS log file viewer and analyzer that supports
      all common GPS log file formats.
    '';
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ womfoo sikmir ];
    platforms = lib.platforms.unix;
  };
})
=======
    homepage = "https://www.gpxsee.org/";
    changelog = "https://build.opensuse.org/package/view_file/home:tumic:GPXSee/gpxsee/gpxsee.changes";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ womfoo sikmir ];
    platforms = platforms.unix;
    broken = isQt6 && stdenv.isDarwin;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
