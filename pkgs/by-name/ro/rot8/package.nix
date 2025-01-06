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
    repo = pname;
    tag = "v${version}";
    hash = "sha256-dHx3vFY0ztyTIlzUi22TYphPD5hvgfHrWaaeoGxnvW0=";
  };

  cargoHash = "sha256-KDg6Ggnm6Cl/1fXqNcc7/jRFJ6KTLVGveJ6Fs3NLlHE=";

  meta = {
    description = "screen rotation daemon for X11 and wlroots";
    homepage = "https://github.com/efernau/rot8";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.smona ];
    mainProgram = "rot8";
    platforms = lib.platforms.linux;
  };
}
