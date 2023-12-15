{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-autoname-workspaces";
  version = "1.1.11";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprland-autoname-workspaces";
    rev = version;
    hash = "sha256-x9MXp2MZtrnVI3W+6xo34uUHuRnpVeXS+3vbyti1p24=";
  };

  cargoHash = "sha256-mSUtFZvq5+rumefJ6I9C6YzRzu64oJ/bTwaa+rrFlL4=";

  meta = with lib; {
    description = "Automatically rename workspaces with icons of started applications";
    homepage = "https://github.com/hyprland-community/hyprland-autoname-workspaces";
    license = licenses.isc;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "hyprland-autoname-workspaces";
    platforms = platforms.linux;
  };
}
