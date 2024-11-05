{
  lib,
  fetchFromGitHub,
  hyprland,
  mkHyprlandPlugin,
  unstableGitUpdater,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hyprspace";
  version = "0-unstable-2024-09-16";

  src = fetchFromGitHub {
    owner = "KZDKM";
    repo = "hyprspace";
    rev = "8f14fa2e10d24742d713f04c278bc7651037b74b";
    hash = "sha256-lMIFDORuyMYHtUPrRWU5WjGcS+ZMrR4/wBSO+sgUVSY=";
  };

  dontUseCmakeConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv Hyprspace.so $out/lib/libhyprspace.so

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/KZDKM/Hyprspace";
    description = "Workspace overview plugin for Hyprland";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ donovanglover ];
  };
}
