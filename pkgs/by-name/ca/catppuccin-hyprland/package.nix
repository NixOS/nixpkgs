{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "catppuccin-hyprland";
  version = "1.3";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "hyprland";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jkk021LLjCLpWOaInzO4Klg6UOR4Sh5IcKdUxIn7Dis=";
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
