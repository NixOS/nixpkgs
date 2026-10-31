{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "gruvbox-material-gtk-theme";
  version = "0-unstable-2024-08-09";

  src = fetchFromGitHub {
    owner = "TheGreatMcPain";
    repo = "gruvbox-material-gtk";
    rev = "808959bcfe8b9409b49a7f92052198f0882ae8bc";
    hash = "sha256-NHjE/HI/BJyjrRfoH9gOKIU8HsUIBPV9vyvuW12D01M=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -d "$out/share/icons"
    cp -a icons/* "$out/share/icons"

    # gtk-2.0 is skipped: it needs gtk-engine-murrine, which is no longer packaged.
    shopt -s extglob

    for theme in themes/*; do
      install -d "$out/share/themes/$(basename "$theme")"
      cp -a "$theme"/!(gtk-2.0) "$out/share/themes/$(basename "$theme")"
    done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "GTK Theme based off of the Gruvbox Material colour palette";
    homepage = "https://github.com/TheGreatMcPain/gruvbox-material-gtk";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
}
