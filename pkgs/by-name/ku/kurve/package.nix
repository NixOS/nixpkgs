{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  kdePackages,
  cava,
  python3,
  qt6,
}:
let
  pythonEnv = python3.withPackages (ps: [ ps.websockets ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kurve";
  version = "0.4.0";
  dontWrapQtApps = true;

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "kurve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ra+ySuvBqmVOTD8TlWDJklXYuwXPb/2a3BSY+gQMiiA=";
  };

  installPhase = ''
    runHook preInstall

    # Substitute Qt Websocket paths in QML files to ensure they work with Nix
    substituteInPlace package/contents/ui/components/ProcessMonitorFallback.qml --replace-fail "import QtWebSockets 1.9" "import \"file:${qt6.qtwebsockets}/lib/qt-6/qml/QtWebSockets\""

    # Set cava path so it gets discovered by nix as runtime dependency
    substituteInPlace package/contents/ui/Cava.qml --replace-fail "cava" "${cava}/bin/cava"
    substituteInPlace package/contents/ui/FullRepresentation.qml --replace-fail "cava -v" "${cava}/bin/cava -v"

    # Set python path so it gets discovered by nix as runtime dependency
    substituteInPlace package/contents/ui/tools/commandMonitor --replace-fail "#!/usr/bin/env python3" "#!${pythonEnv}/bin/python3"

    mkdir -p $out/share/plasma/plasmoids/luisbocanegra.audio.visualizer
    cp -r package/* $out/share/plasma/plasmoids/luisbocanegra.audio.visualizer
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "KDE Plasma widget displaying CAVA audio visualizations.";
    homepage = "https://github.com/luisbocanegra/kurve";
    changelog = "https://github.com/luisbocanegra/kurve/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ chrisheib ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
