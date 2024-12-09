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
  version = "0-unstable-2024-11-29";

  src = fetchFromGitHub {
    owner = "dawsers";
    repo = "hyprscroller";
    rev = "50a87a8a7dc56494a5b71e95182ef4b907d71448";
    hash = "sha256-4Gzj0HWovu0hzzw+2zEXne7vDmP6yIK2GmtURB1EZxQ=";
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
