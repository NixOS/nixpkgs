{ lib
, stdenv
, fetchFromGitHub
, qmake
, nix-update-script
, qtbase
, qttools
, qtlocation ? null # qt5 only
, qtpositioning ? null # qt6 only
, qtserialport
, qtsvg
, wrapQtAppsHook
}:

let
  isQt6 = lib.versions.major qtbase.version == "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gpxsee";
  version = "13.26";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = finalAttrs.version;
    hash = "sha256-EIeUcSHJXpd1/90fAPrP9F/DVyZhkcZk8MJd9VO1D70=";
  };

  buildInputs = [
    qtserialport
  ] ++ (if isQt6 then [
    qtbase
    qtpositioning
    qtsvg
  ] else [
    qtlocation
  ]);

  nativeBuildInputs = [
    qmake
    qttools
    wrapQtAppsHook
  ];

  preConfigure = ''
    lrelease gpxsee.pro
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv GPXSee.app $out/Applications
    mkdir -p $out/bin
    ln -s $out/Applications/GPXSee.app/Contents/MacOS/GPXSee $out/bin/gpxsee
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    broken = isQt6 && stdenv.hostPlatform.isDarwin;
    changelog = "https://build.opensuse.org/package/view_file/home:tumic:GPXSee/gpxsee/gpxsee.changes";
    description = "GPS log file viewer and analyzer";
    mainProgram = "gpxsee";
    homepage = "https://www.gpxsee.org/";
    license = lib.licenses.gpl3Only;
    longDescription = ''
      GPXSee is a Qt-based GPS log file viewer and analyzer that supports
      all common GPS log file formats.
    '';
    maintainers = with lib.maintainers; [ womfoo sikmir ];
    platforms = lib.platforms.unix;
  };
})
