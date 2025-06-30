{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  qt6,
}:

stdenvNoCC.mkDerivation {
  pname = "catppuccin-sddm-corners";
  version = "0-unstable-2025-03-25";

  src = fetchFromGitHub {
    owner = "khaneliman";
    repo = "catppuccin-sddm-corners";
    rev = "10831dea7298bd1c3262a7f48417b5af1b92ed99";
    hash = "sha256-nQImL5eDMENNDCXEqgrL2eszWXtBpbVlzjMxNdpxZlQ=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontWrapQtApps = true;

  propagatedUserEnvPkgs = with qt6; [
    qt5compat
    qtwayland
    qtquick3d
    qtsvg
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/sddm/themes/"
    cp -r catppuccin/ "$out/share/sddm/themes/catppuccin-sddm-corners"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Soothing pastel theme for SDDM based on corners theme";
    homepage = "https://github.com/khaneliman/sddm-catppuccin-corners";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.linux;
  };
}
