{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  hyprland,
  unstableGitUpdater,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hypr-dynamic-cursors";
  version = "0-unstable-2024-11-19";

  src = fetchFromGitHub {
    owner = "VirtCode";
    repo = "hypr-dynamic-cursors";
    rev = "81f4b964f997a3174596ef22c7a1dee8a5f616c7";
    hash = "sha256-3SDwq2i2QW9nu7HBCPuDtLmrwLt2kajzImBsawKRZ+s=";
  };

  dontUseCmakeConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv out/dynamic-cursors.so $out/lib/libhypr-dynamic-cursors.so

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Plugin to make your Hyprland cursor more realistic";
    homepage = "https://github.com/VirtCode/hypr-dynamic-cursors";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.linux;
  };
}
