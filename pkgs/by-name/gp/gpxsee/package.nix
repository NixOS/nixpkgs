{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  qt6,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpxsee";
  version = "14.1";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    tag = finalAttrs.version;
    hash = "sha256-wXlmly2KtjyY5hdBAroP3H93+1tg5rtFPpDKFn3jnhA=";
  };

  buildInputs = [
    qt6.qtbase
    qt6.qtpositioning
    qt6.qtserialport
    qt6.qtsvg
  ];

  nativeBuildInputs = [
    qt6.qmake
    qt6.qttools
    qt6.wrapQtAppsHook
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=(''${gappsWrapperArgs[@]})
  '';

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
    changelog = "https://build.opensuse.org/package/view_file/home:tumic:GPXSee/gpxsee/gpxsee.changes";
    description = "GPS log file viewer and analyzer";
    mainProgram = "gpxsee";
    homepage = "https://www.gpxsee.org/";
    license = lib.licenses.gpl3Only;
    longDescription = ''
      GPXSee is a Qt-based GPS log file viewer and analyzer that supports
      all common GPS log file formats.
    '';
    maintainers = with lib.maintainers; [
      womfoo
      sikmir
    ];
    platforms = lib.platforms.unix;
  };
})
