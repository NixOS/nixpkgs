{
  lib,
  mkHyprlandPlugin,
  hyprland,
  fetchFromGitHub,
  nix-update-script,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hyprfocus";
  version = "0-unstable-2025-01-04";

  src = fetchFromGitHub {
    owner = "pyt0xic";
    repo = "hyprfocus";
    rev = "de6eaf5846b970b697bdf0e20e731b9fbe08654d";
    hash = "sha256-o8uDSynpHAgpQZMjXyDiyQbxi+QgxY62uZeB08PcL/A=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv hyprfocus.so $out/lib/libhyprfocus.so

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  meta = {
    homepage = "https://github.com/pyt0xic/hyprfocus";
    description = "Focus animation plugin for Hyprland inspired by Flashfocus";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.linux;
    broken = true; # Doesn't work on Hyprland v0.47.0+
  };
}
