{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4-layer-shell,
  hyprland,
  gcc,
  pixman,
  libadwaita,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprshell";
  version = "4.10.8";

  src = fetchFromGitHub {
    owner = "H3rmt";
    repo = "hyprshell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GXegc0W2xiRuSCjMpVc5mmKP5YFCYn87M/POTalISCA=";
  };

  cargoHash = "sha256-idvY6AOLyx22Gy01kQyA4V8j0VupP5JNswsY4K5Oq9M=";

  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    libadwaita
    gtk4-layer-shell
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : '${lib.makeBinPath [ gcc ]}'
      --prefix CPATH : '${
        lib.makeIncludePath (
          hyprland.buildInputs
          ++ [
            hyprland
            pixman
          ]
        )
      }'
    )
  '';

  meta = {
    description = "Modern GTK4-based window switcher and application launcher for Hyprland";
    mainProgram = "hyprshell";
    homepage = "https://github.com/H3rmt/hyprshell";
    license = lib.licenses.mit;
    platforms = hyprland.meta.platforms;
    maintainers = with lib.maintainers; [ arminius-smh ];
  };
})
