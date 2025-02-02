{
  lib,
  fetchFromGitHub,
  hyprland,
  mkHyprlandPlugin,
  nix-update-script,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hyprspace";
  version = "0-unstable-2025-01-18";

  src = fetchFromGitHub {
    owner = "KZDKM";
    repo = "hyprspace";
    rev = "1b5865f4ac9a04ba614df50de7acfaa40dcb852f";
    hash = "sha256-YQgW4QifYIcNaFF4nMw0LpllXn0rhk/Yb6cwyH3PB9o=";
  };

  dontUseCmakeConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv Hyprspace.so $out/lib/libhyprspace.so

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    homepage = "https://github.com/KZDKM/Hyprspace";
    description = "Workspace overview plugin for Hyprland";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ donovanglover ];
    broken = true; # Doesn't work on Hyprland v0.47.0+
  };
}
