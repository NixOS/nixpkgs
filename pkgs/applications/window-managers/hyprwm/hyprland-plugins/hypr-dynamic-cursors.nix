{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  hyprland,
  nix-update-script,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hypr-dynamic-cursors";
  version = "0-unstable-2025-01-27";

  src = fetchFromGitHub {
    owner = "VirtCode";
    repo = "hypr-dynamic-cursors";
    rev = "4d1d88522bbeefd07a9113dd5449a0a288d11ba8";
    hash = "sha256-BTYq6SDfUvhLH/Zjc0sGr19m5qnjB9Vn3OfIpxumsyk=";
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
