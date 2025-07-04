{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-monitor-attached";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = "hyprland-monitor-attached";
    rev = version;
    hash = "sha256-+bgOOm1B513COcWdUIJ/+GREQH5CR8/RNOcZVkjO2hI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pBg5R7k3xEE1EoSdLO4jmibTnGE+ndZnkWeMO+UXN6Q=";

  meta = with lib; {
    description = "Automatically run a script when a monitor connects (or disconnects) in Hyprland";
    homepage = "https://github.com/coffebar/hyprland-monitor-attached";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
    mainProgram = "hyprland-monitor-attached";
    platforms = platforms.linux;
  };
}
