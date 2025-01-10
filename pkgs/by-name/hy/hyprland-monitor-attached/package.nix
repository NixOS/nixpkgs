{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-monitor-attached";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = "hyprland-monitor-attached";
    rev = version;
    hash = "sha256-+bgOOm1B513COcWdUIJ/+GREQH5CR8/RNOcZVkjO2hI=";
  };

  cargoHash = "sha256-vQfDsP2Tc+Kj95wXIzPTlf6kRdBgdio0QkM9EJRjZjE=";

  meta = with lib; {
    description = "Automatically run a script when a monitor connects (or disconnects) in Hyprland";
    homepage = "https://github.com/coffebar/hyprland-monitor-attached";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
    mainProgram = "hyprland-monitor-attached";
    platforms = platforms.linux;
  };
}
