{
  lib,
  mkHyprlandPlugin,
  hyprland,
  fetchFromGitHub,
  nix-update-script,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hyprfocus";
  version = "0-unstable-2025-04-01";

  src = fetchFromGitHub {
    owner = "daxisunder";
    repo = "hyprfocus";
    rev = "8061b05a04432da5331110e0ffaa8c81e1035725";
    hash = "sha256-n8lCf4zQehWEK6UJWcLuGUausXuRgqggGuidc85g20I=";
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
