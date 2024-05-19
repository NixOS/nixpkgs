{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, wrapGAppsHook3
, gtk-layer-shell
}:

buildGoModule rec {
  pname = "nwg-dock-hyprland";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pzOdWv98tHZg6Xn58z5DlM1H0IOQ+ohfXEZRLZr8mz0=";
  };

  vendorHash = "sha256-bK3SpydIO943e7zti6yWQ+JqmdF4NkAAtelNBt4Q/+s=";

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
