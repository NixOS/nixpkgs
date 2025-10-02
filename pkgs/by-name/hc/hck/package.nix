{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "hck";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = "hck";
    rev = "v${version}";
    hash = "sha256-XnkLKslZY2nvjO5ZeTIBJ0Y47/JPhfIS/F5KKqm5iwI=";
  };

  cargoHash = "sha256-NKyBC/kD2tq61su7tUsSPQ2Rr4YBYUsotL55aCoFNGw=";

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Close to drop in replacement for cut that can use a regex delimiter instead of a fixed string";
    homepage = "https://github.com/sstadick/hck";
    changelog = "https://github.com/sstadick/hck/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      unlicense
    ];
    maintainers = with lib.maintainers; [
      figsoda
      gepbird
    ];
    mainProgram = "hck";
  };
}
