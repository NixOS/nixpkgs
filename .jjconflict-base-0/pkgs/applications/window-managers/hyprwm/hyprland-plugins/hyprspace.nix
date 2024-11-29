{
  lib,
  fetchFromGitHub,
  hyprland,
  mkHyprlandPlugin,
  unstableGitUpdater,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hyprspace";
  version = "0-unstable-2024-11-02";

  src = fetchFromGitHub {
    owner = "KZDKM";
    repo = "hyprspace";
    rev = "260f386075c7f6818033b05466a368d8821cde2d";
    hash = "sha256-cwbcYg+rPmvHFFtAEie7nw5IaBidrTYe5XsTlhOyoyQ=";
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
