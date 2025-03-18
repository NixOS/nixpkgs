{
  lib,
  mkHyprlandPlugin,
  hyprland,
  fetchFromGitHub,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hyprfocus";
  version = "0-unstable-2024-05-30";

  src = fetchFromGitHub {
    owner = "pyt0xic";
    repo = "hyprfocus";
    rev = "aa7262d3a4564062f97b9cfdad47fd914cfb80f2";
    hash = "sha256-R1ZgNhQkoS6ZHRRKB+j5vYgRANfYO//sHbrD7moUTx0=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv hyprfocus.so $out/lib/libhyprfocus.so

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/pyt0xic/hyprfocus";
    description = "Focus animation plugin for Hyprland inspired by Flashfocus";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.linux;
  };
}
