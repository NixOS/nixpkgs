{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-autoname-workspaces";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprland-autoname-workspaces";
    rev = "v${version}";
    hash = "sha256-OtKPJZI0YKi98HUY4IDU8LRg6dTaD68OgVi9FzfjDbA=";
  };

  cargoHash = "sha256-ueT85rKa2PGvp/R/ZXkDGUFIXyYNpDErg4W8WcXAPIw=";

  meta = with lib; {
    description = "Automatically rename workspaces with icons of started applications";
    homepage = "https://github.com/hyprland-community/hyprland-autoname-workspaces";
    license = licenses.isc;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "hyprland-autoname-workspaces";
    platforms = platforms.linux;
  };
}
