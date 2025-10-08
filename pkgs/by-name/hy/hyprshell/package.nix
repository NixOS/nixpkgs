{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  gtk4-layer-shell,
  hyprland,
  gcc,
  pixman,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprshell";
  version = "4.7.1";

  src = fetchFromGitHub {
    owner = "H3rmt";
    repo = "hyprshell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SRw1X2oC7V/h2Tqo/wTXcu6d1kKVMPrW2HGsNGE4nCA=";
  };

  cargoHash = "sha256-ULuztkKukOyfQkiGZY7HtWn5nSs2PWX8B86FQP/z7RU=";

  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    gtk4
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
