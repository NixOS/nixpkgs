{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-monitor-attached";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = "hyprland-monitor-attached";
    rev = version;
    hash = "sha256-McenpaoEjQIB709VlLkyVGoUwVoMe7TJPb8Lrh1efw8=";
  };

  cargoHash = "sha256-QH32NYZJcSxTMgHZKqksy2+DLw62G+knJgoj6OGRfQE=";

  meta = with lib; {
    description = "Automatically run a script when a monitor connects (or disconnects) in Hyprland";
    homepage = "https://github.com/coffebar/hyprland-monitor-attached";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
    mainProgram = "hyprland-monitor-attached";
    platforms = platforms.linux;
  };
}
