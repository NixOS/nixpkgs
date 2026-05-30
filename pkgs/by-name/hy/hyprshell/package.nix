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
  version = "4.10.4";

  src = fetchFromGitHub {
    owner = "H3rmt";
    repo = "hyprshell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-33qau/UP4CHBwL/6damFBTjsy/6gX8Nuh87uuhmqVfA=";
  };

  cargoHash = "sha256-6m0ZvZBO30DbhcBJQWBx3PoHeZuS2FKiGJhcJx1eEfo=";

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
