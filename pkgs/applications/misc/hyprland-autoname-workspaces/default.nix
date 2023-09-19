{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-autoname-workspaces";
  version = "1.1.10";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprland-autoname-workspaces";
    rev = version;
    hash = "sha256-I0ELCexJxZgbTLzO4GtvOtaIghzVND8kgOFmlQ0oca8=";
  };

  cargoHash = "sha256-MmWYsYRxrcEtL+efK1yCzq5b+PsrsrG1flSXn2kGdYs=";

  meta = with lib; {
    description = "Automatically rename workspaces with icons of started applications";
    homepage = "https://github.com/hyprland-community/hyprland-autoname-workspaces";
    license = licenses.isc;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "hyprland-autoname-workspaces";
    platforms = platforms.linux;
  };
}
