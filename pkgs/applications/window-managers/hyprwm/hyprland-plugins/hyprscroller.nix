{
  lib,
  mkHyprlandPlugin,
  hyprland,
  cmake,
  fetchFromGitHub,
  unstableGitUpdater,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hyprscroller";
  version = "0-unstable-2024-07-04";

  src = fetchFromGitHub {
    owner = "dawsers";
    repo = "hyprscroller";
    rev = "bef840b3f0fd3d37b5c1c9f2704b2efb60173184";
    hash = "sha256-vkpGSseA7n0/Y+83snbEe7Z++2akdDbvv7eZzM9V3wI=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv hyprscroller.so $out/lib/libhyprscroller.so

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/dawsers/hyprscroller";
    description = "Hyprland layout plugin providing a scrolling layout like PaperWM";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.linux;
  };
}
