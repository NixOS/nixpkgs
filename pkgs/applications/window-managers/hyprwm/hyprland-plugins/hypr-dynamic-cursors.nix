{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  nix-update-script,
}:

mkHyprlandPlugin {
  pluginName = "hypr-dynamic-cursors";
  version = "0-unstable-2025-11-19";

  src = fetchFromGitHub {
    owner = "VirtCode";
    repo = "hypr-dynamic-cursors";
    rev = "85e6a93f311132d775538c4a016b637b366d2a44";
    hash = "sha256-3+k074XQ4quCWQ/WLEeYTTD+AlDlxtzKvH9gkWqn+8Y=";
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
