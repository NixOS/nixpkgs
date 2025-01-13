{
  lib,
  fetchFromGitHub,
  hyprland,
  mkHyprlandPlugin,
  nix-update-script,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hyprspace";
  version = "0-unstable-2024-12-08";

  src = fetchFromGitHub {
    owner = "KZDKM";
    repo = "hyprspace";
    rev = "e2d561c933cd085d68bf0b39c4f78870ad0abbc2";
    hash = "sha256-YiLUDw14NaavML8y9rxXxO7q+j3b/ghQhBmIy0+/Zmk=";
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
  };
}
