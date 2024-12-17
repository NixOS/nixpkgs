{
  lib,
  mkHyprlandPlugin,
  hyprland,
  fetchFromGitHub,
  nix-update-script,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hyprfocus";
  version = "0-unstable-2024-10-09";

  src = fetchFromGitHub {
    owner = "pyt0xic";
    repo = "hyprfocus";
    rev = "bead5b77d80f222c006d1a6c6f44ee8b02021d73";
    hash = "sha256-qIl7opF7fA1ZmC91TGQ7D12tB7kHc6Sn9DrfUN6sbBY=";
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
  };
}
