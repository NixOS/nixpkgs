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
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-dock-hyprland";
    rev = "refs/tags/v${version}";
    hash = "sha256-Vp8JmRQf71vezdknzifxlK7zTlorwiEHsyXpmy6mxIE=";
  };

  vendorHash = "sha256-RBU0l4YRtV5JPH1dLT+lZ05jmxRwyn3glMUKHw1Eg8g=";

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
