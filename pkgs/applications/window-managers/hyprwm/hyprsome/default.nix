{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprsome";
  version = "0.1.11";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-xNbBrLbyAbqb2PanlCD14TTkckHDwCFAX2iMQJWI/yk=";
  };

  cargoHash = "sha256-GDjul40Kpk7B6KKT55WxaoOL/2BZDv+5MeV6Agb0HJ4=";

  meta = with lib; {
    description = "Awesome-like workspaces for Hyprland";
    homepage = "https://crates.io/crates/hyprsome";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hhydraa ];
    platforms = platforms.linux;
  };
}
