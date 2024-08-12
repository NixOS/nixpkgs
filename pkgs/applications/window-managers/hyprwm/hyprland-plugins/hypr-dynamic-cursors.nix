{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  hyprland,
  unstableGitUpdater,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hypr-dynamic-cursors";
  version = "0-unstable-2024-08-01";

  src = fetchFromGitHub {
    owner = "VirtCode";
    repo = "hypr-dynamic-cursors";
    rev = "ed2ff68862ae02e04dd06488eb7228e4412f5c33";
    hash = "sha256-02G/SPd/X7zSIFF3V6dkh8mGGWoO0/m6/Yld7HyPmJs=";
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
