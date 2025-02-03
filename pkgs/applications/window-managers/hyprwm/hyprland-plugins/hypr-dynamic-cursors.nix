{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  hyprland,
  nix-update-script,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hypr-dynamic-cursors";
  version = "0-unstable-2025-02-02";

  src = fetchFromGitHub {
    owner = "VirtCode";
    repo = "hypr-dynamic-cursors";
    rev = "fd6214629937949ecd8a39f4b5ebbce2afac0dd5";
    hash = "sha256-Fg4+6Yko8V9b19/62jfKH0IWTiiRDMso1P1TnjAcs/8=";
  };

  dontUseCmakeConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv out/dynamic-cursors.so $out/lib/libhypr-dynamic-cursors.so

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Plugin to make your Hyprland cursor more realistic";
    homepage = "https://github.com/VirtCode/hypr-dynamic-cursors";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.linux;
  };
}
