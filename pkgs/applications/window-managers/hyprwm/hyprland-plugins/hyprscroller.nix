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
  version = "0-unstable-2024-09-06";

  src = fetchFromGitHub {
    owner = "dawsers";
    repo = "hyprscroller";
    rev = "07671d7d42b92a85fc7e62cd8f02b0d9c52a8dea";
    hash = "sha256-RLI202fBXz+mDXX5Em70FU+16ChbA/YtpORYiOSX8uc=";
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
