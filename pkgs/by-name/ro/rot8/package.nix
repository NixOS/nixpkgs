{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "rot8";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "efernau";
    repo = "rot8";
    tag = "v${version}";
    hash = "sha256-dHx3vFY0ztyTIlzUi22TYphPD5hvgfHrWaaeoGxnvW0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-MZz8IZDux9VEDDLQjkT96smNsygY1vYG2QBw3Q09hqw=";

  meta = with lib; {
    description = "screen rotation daemon for X11 and wlroots";
    homepage = "https://github.com/efernau/rot8";
    license = licenses.mit;
    maintainers = [ maintainers.smona ];
    mainProgram = "rot8";
    platforms = platforms.linux;
  };
}
