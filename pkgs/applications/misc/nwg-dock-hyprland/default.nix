{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, gtk-layer-shell
}:

buildGoModule rec {
  pname = "nwg-dock-hyprland";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aPCz9m2Qnge8XhEbvpXb2U/eT5xvJkaSoorkkoY3gp0=";
  };

  vendorHash = "sha256-GhcrIVnZRbiGTfeUAWvslOVWDZmoL0ZRnjgTtQgxe2Q=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = [ gtk-layer-shell ];

  meta = with lib; {
    description = "GTK3-based dock for Hyprland";
    homepage = "https://github.com/nwg-piotr/nwg-dock-hyprland";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aleksana ];
  };
}
