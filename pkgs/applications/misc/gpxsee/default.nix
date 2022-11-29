{ lib
, stdenv
, fetchFromGitHub
, qmake
, nix-update-script
, substituteAll
, qtbase
, qttools
, qttranslations
, qtlocation ? null # qt5 only
, qtpositioning ? null # qt6 only
, qtpbfimageplugin
, qtsvg
, qt5compat ? null # qt6 only
, wrapQtAppsHook
}:

let
  isQt6 = lib.versions.major qtbase.version == "6";

in
stdenv.mkDerivation rec {
  pname = "gpxsee";
  version = "11.9";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    hash = "sha256-R/Kuk4nRJg3ozNNmzzNDnGcsmBmlk0g9d+F8JwLFz98=";
  };

  patches = (substituteAll {
    # See https://github.com/NixOS/nixpkgs/issues/86054
    src = ./fix-qttranslations-path.diff;
    inherit qttranslations;
  });

  buildInputs = [ qtpbfimageplugin ]
    ++ (if isQt6 then [
    qtbase
    qtpositioning
    qtsvg
    qt5compat
  ] else [
    qtlocation
  ]);

  nativeBuildInputs = [ qmake qttools wrapQtAppsHook ];

  preConfigure = ''
    lrelease gpxsee.pro
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv GPXSee.app $out/Applications
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

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
    platforms = platforms.unix;
    broken = isQt6 && stdenv.isDarwin;
  };
}
