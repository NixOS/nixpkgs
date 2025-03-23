{
  lib,
  mkHyprlandPlugin,
  hyprland,
  cmake,
  fetchFromGitHub,
  nix-update-script,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hyprscroller";
  version = "0-unstable-2025-03-07";

  src = fetchFromGitHub {
    owner = "dawsers";
    repo = "hyprscroller";
    rev = "fb3b2ec63c85f22a107bd635890fcb1afc30b01f";
    hash = "sha256-FErWOeUmyFWPNjE+EYWVvVwXGO7+4lVqZBwiapXa6Yw=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv hyprscroller.so $out/lib/libhyprscroller.so

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    homepage = "https://github.com/dawsers/hyprscroller";
    description = "Hyprland layout plugin providing a scrolling layout like PaperWM";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.linux;
  };
}
