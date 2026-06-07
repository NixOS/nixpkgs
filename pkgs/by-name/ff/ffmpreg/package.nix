{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "ffmpreg";
  version = "0.1.2-unstable-2026-03-25";

  src = fetchFromGitHub {
    owner = "yazaldefilimone";
    repo = "ffmpreg";
    rev = "a6fca970b98357ccd275acd797673ef7cf4ca02f";
    hash = "sha256-p2dtNmJ7fXFzgsfg32Tmr6xr1wuZAHziNgMeUOfyjgw=";
  };

  cargoHash = "sha256-GxUBhFWoAq6zCDHWTiZ/pC6BWu4JcW71Sh9Du2H36wg=";

  meta = {
    description = "Experimental safe Rust-native multimedia toolkit for decoding, transforming, and encoding audio and video";
    homepage = "https://github.com/yazaldefilimone/ffmpreg";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aprl ];
    mainProgram = "ffmpreg";
  };
}
