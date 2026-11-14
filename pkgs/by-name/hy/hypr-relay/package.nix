{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  __structuredAttrs = true;

  pname = "hypr-relay";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Vega-0b1";
    repo = "hypr-relay";
    rev = "v0.3.0";
    hash = "sha256-IYiUwekQS6cSZ/S/jy6IOmPQOhMRlJpPF5aDS7autXg=";
  };

  cargoHash = "sha256-IsTS6OZmGCWFIwl70HOa1f+dEiqriWbAKmvHJ4fSRYg=";

  meta = {
    description = "Lightweight daemon for Hyprland that bridges system events to desktop notifications";
    homepage = "https://github.com/Vega-0b1/hypr-relay";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jcvega ];
    mainProgram = "hypr-relay";
    platforms = lib.platforms.linux;
  };
}
