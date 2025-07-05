{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  kdePackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kurve";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "kurve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ra+ySuvBqmVOTD8TlWDJklXYuwXPb/2a3BSY+gQMiiA=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/luisbocanegra.audio.visualizer
    cp -r package/* $out/share/plasma/plasmoids/luisbocanegra.audio.visualizer
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "KDE Plasma widget displaying CAVA audio visualizations. Requires `cava`, `qt6.qtwebsockets` and `(python3.withPackages (ps: [ps.websockets]))` to be installed.";
    homepage = "https://github.com/luisbocanegra/kurve";
    changelog = "https://github.com/luisbocanegra/kurve/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ chrisheib ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
