{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-autoname-workspaces";
  version = "1.1.15";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprland-autoname-workspaces";
    rev = version;
    hash = "sha256-oXVKee3YAMXtVJBqJGt1SpH0KFzvIB278EN69A2OeXY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zkv8Eb4k3Hu4PSQKOZTEu0dNFLeoKq03uY5S7G8fo4U=";

  doCheck = false;

  meta = with lib; {
    description = "Automatically rename workspaces with icons of started applications";
    homepage = "https://github.com/hyprland-community/hyprland-autoname-workspaces";
    license = licenses.isc;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "hyprland-autoname-workspaces";
    platforms = platforms.linux;
  };
}
