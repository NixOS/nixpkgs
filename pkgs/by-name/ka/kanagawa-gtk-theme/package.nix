{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kanagawa-gtk-theme";
  version = "0-unstable-2023-07-03";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Kanagawa-GKT-Theme";
    rev = "35936a1e3bbd329339991b29725fc1f67f192c1e";
    hash = "sha256-BZRmjVas8q6zsYbXFk4bCk5Ec/3liy9PQ8fqFGHAXe0=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

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
    description = "GTK theme with the Kanagawa colour palette";
    homepage = "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ FlorianFranzen ];
  };
})
