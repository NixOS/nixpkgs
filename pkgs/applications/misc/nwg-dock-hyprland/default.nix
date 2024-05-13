{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, wrapGAppsHook3
, gtk-layer-shell
}:

buildGoModule rec {
  pname = "nwg-dock-hyprland";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cdNxaOnm98RcPG2o0GaBETpd+Zo2nlgrFv+2PiHOwUI=";
  };

  vendorHash = "sha256-JEzc950c4EGOYMLgpL8PXENkGlWSX8Z4A4jCx1B99X8=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ pkg-config wrapGAppsHook3 ];
  buildInputs = [ gtk-layer-shell ];

  meta = with lib; {
    description = "GTK3-based dock for Hyprland";
    mainProgram = "nwg-dock-hyprland";
    homepage = "https://github.com/nwg-piotr/nwg-dock-hyprland";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aleksana ];
  };
}
