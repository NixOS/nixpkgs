{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "catppuccin-hyprland";
  version = "2.0.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "hyprland";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jGqBpSQa793phan9PeU2yXMX1nxzYClthQSeTwdqgEQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    cp -rva $src/themes $out/share/themes/catppuccin-hyprland-themes

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Soothing pastel theme for Hyprland";
    homepage = "https://github.com/catppuccin/hyprland";
    changelog = "https://github.com/catppuccin/hyprland/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ElSebas41 ];
    platforms = lib.platforms.all;
  };
})
