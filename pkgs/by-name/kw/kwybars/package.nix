{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  pkg-config,
  cava,
  gdk-pixbuf,
  gtk4,
  gtk4-layer-shell,
  libnotify,
  pipewire,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kwybars";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "naurissteins";
    repo = "Kwybars";
    tag = finalAttrs.version;
    hash = "sha256-2op54DbnLtp7L2yjLvzdaVG7eFlaW6JT5dCUXEgwWoU=";
  };

  cargoHash = "sha256-11+YsAHXaNOcJ6NB/5u39UHqwJsMJKGmO7DlBpZIh5E=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    gdk-pixbuf
    gtk4
    gtk4-layer-shell
    libnotify
    pipewire
  ];

  cargoBuildFlags = [ "--workspace" ];
  cargoCheckFlags = [ "--workspace" ];

  postInstall = ''
    install -Dm644 assets/examples/*.toml -t "$out/share/kwybars/examples"
    install -Dm644 assets/themes/*.toml -t "$out/share/kwybars/themes"
    install -Dm644 docs/man/*.1 -t "$out/share/man/man1"

    wrapProgram "$out/bin/kwybars-daemon" \
      --set KWYBARS_THEMES_DIR "$out/share/kwybars/themes" \
      --prefix PATH : ${
        lib.makeBinPath [
          cava
          libnotify
        ]
      }:$out/bin

    wrapProgram "$out/bin/kwybars-overlay" \
      --set KWYBARS_THEMES_DIR "$out/share/kwybars/themes" \
      --prefix PATH : ${
        lib.makeBinPath [
          cava
          libnotify
        ]
      }:$out/bin

    wrapProgram "$out/bin/kwybarsctl" \
      --set KWYBARS_THEMES_DIR "$out/share/kwybars/themes"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GTK4 real-time audio visualizer overlay for Wayland";
    homepage = "https://github.com/naurissteins/Kwybars";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ naurissteins ];
    platforms = lib.platforms.linux;
  };
})
