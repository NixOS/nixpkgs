{
  lib,
  fetchFromGitHub,
  mkHyprlandPlugin,
  nix-update-script,
}:

mkHyprlandPlugin {
  pluginName = "hyprspace";
  version = "0-unstable-2025-09-28";

  src = fetchFromGitHub {
    owner = "KZDKM";
    repo = "hyprspace";
    rev = "e54884da1d6a1af76af9d053887bf3750dd554fd";
    hash = "sha256-QhcOFLJYC9CiSVPkci62ghMEAJChzl+L98To1pKvnRQ=";
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
