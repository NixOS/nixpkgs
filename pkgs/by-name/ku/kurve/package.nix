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
  version = "2.0.0";
  dontWrapQtApps = true;

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "kurve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qw/6V3TWGZFL8dgyDUxzBr4U6/jaX9uwpyg3Bd3pKdg=";
  };

  installPhase = ''
    runHook preInstall

    # Substitute Qt Websocket paths in QML files to ensure they work with Nix
    substituteInPlace package/contents/ui/components/ProcessMonitorFallback.qml --replace-fail "import QtWebSockets" "import \"file:${qt6.qtwebsockets}/lib/qt-6/qml/QtWebSockets\""

    # Set cava path so it gets discovered by nix as runtime dependency
    substituteInPlace package/contents/ui/Cava.qml --replace-fail "cava -p" "${cava}/bin/cava -p"
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
