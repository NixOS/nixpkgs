{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  gtk-layer-shell,
}:

buildGoModule rec {
  pname = "nwg-dock-hyprland";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-dock-hyprland";
    rev = "refs/tags/v${version}";
    hash = "sha256-pSkA4N/scVZgRQ2NL8iUUq7DmAhXVNS2o4lqDZDELE0=";
  };

  vendorHash = "sha256-FBuk6qNfJ7mVzKoD6Q/O8zo+AfAPUyXExlLu5uGbHBk=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
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
