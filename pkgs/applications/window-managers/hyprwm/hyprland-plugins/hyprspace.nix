{
  lib,
  fetchFromGitHub,
  mkHyprlandPlugin,
  nix-update-script,
}:

mkHyprlandPlugin {
  pluginName = "hyprspace";
  version = "0-unstable-2025-07-16";

  src = fetchFromGitHub {
    owner = "KZDKM";
    repo = "hyprspace";
    rev = "0a82e3724f929de8ad8fb04d2b7fa128493f24f7";
    hash = "sha256-rTItuAWpzICMREF8Ww8cK4hYgNMRXJ4wjkN0akLlaWE=";
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
