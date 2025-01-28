{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  gobject-introspection,
  gtk-layer-shell,
}:

buildGoModule rec {
  pname = "nwg-dock-hyprland";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-dock-hyprland";
    tag = "v${version}";
    hash = "sha256-l2JB+CmdQg/bDXneJ+rjv4z6xjB+BERh0rLZFETCMtE=";
  };

  vendorHash = "sha256-3ubDvtl/FvVyoRMRNBhwCoIJkJNFvlrWue+cNNGe5eI=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [ gtk-layer-shell ];

  postInstall = ''
    install -d $out/share/nwg-dock-hyprland
    cp -r images $out/share/nwg-dock-hyprland/images
    install -Dm644 config/style.css $out/share/nwg-dock-hyprland/style.css
  '';

  meta = {
    description = "GTK3-based dock for Hyprland";
    mainProgram = "nwg-dock-hyprland";
    homepage = "https://github.com/nwg-piotr/nwg-dock-hyprland";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
