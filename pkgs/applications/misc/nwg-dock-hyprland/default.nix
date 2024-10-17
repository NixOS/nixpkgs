{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, wrapGAppsHook3
, gtk-layer-shell
}:

buildGoModule rec {
  pname = "nwg-dock-hyprland";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-dock-hyprland";
    rev = "v${version}";
    hash = "sha256-iamDOQcQJRdFVnwffWPIXHlY0J4orfrEbfLzaoeV+KM=";
  };

  vendorHash = "sha256-cZ5w7B8bi0faOVWoQ6eeW5ejCZJgnNB91DQalC75mPo=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ pkg-config wrapGAppsHook3 ];
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
