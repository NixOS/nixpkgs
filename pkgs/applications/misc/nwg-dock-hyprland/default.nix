{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, gtk-layer-shell
}:

buildGoModule rec {
  pname = "nwg-dock-hyprland";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Lekvk3tQfeOR+Ltbc5b7TMiUZpktZ2nvCtUncrFb+Kc=";
  };

  vendorHash = "sha256-5fN/6HASfTMb80YYAIoWRqnRGMvvX4d8C2UvOc0jQU0=";

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
