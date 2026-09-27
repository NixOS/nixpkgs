{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprland-monitor-attached";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "coffebar";
    repo = "hyprland-monitor-attached";
    rev = finalAttrs.version;
    hash = "sha256-+bgOOm1B513COcWdUIJ/+GREQH5CR8/RNOcZVkjO2hI=";
  };

  cargoHash = "sha256-pBg5R7k3xEE1EoSdLO4jmibTnGE+ndZnkWeMO+UXN6Q=";

  meta = {
    description = "Automatically run a script when a monitor connects (or disconnects) in Hyprland";
    homepage = "https://github.com/coffebar/hyprland-monitor-attached";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bddvlpr ];
    mainProgram = "hyprland-monitor-attached";
    platforms = lib.platforms.linux;
  };
})
