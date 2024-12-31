{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  hyprland,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hypr-dynamic-cursors";
  version = "0-unstable-2024-07-06";

  src = fetchFromGitHub {
    owner = "VirtCode";
    repo = "hypr-dynamic-cursors";
    rev = "85423b074e112f28e84f6276d31d1548906a625e";
    hash = "sha256-lCAZ/7xtOE6P7uPIX2uQgC0nDOBZefWYO3O3izRx19E=";
  };

  dontUseCmakeConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv out/dynamic-cursors.so $out/lib/libdynamic-cursors.so

    runHook postInstall
  '';

  meta = {
    description = "Plugin to make your Hyprland cursor more realistic";
    homepage = "https://github.com/VirtCode/hypr-dynamic-cursors";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.linux;
  };
}
