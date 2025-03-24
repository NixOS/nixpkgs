{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  hyprland,
  nix-update-script,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hypr-dynamic-cursors";
  version = "0-unstable-2025-03-06";

  src = fetchFromGitHub {
    owner = "VirtCode";
    repo = "hypr-dynamic-cursors";
    rev = "261bc1668f7de45b48ba6a40d5d727025575390b";
    hash = "sha256-2HSbWe1r5DYulPzMXZYSluiwG/T+5904YmJSrPJ8tEo=";
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
