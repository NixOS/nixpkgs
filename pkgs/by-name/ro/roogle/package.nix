{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "roogle";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "hkmatsumoto";
    repo = "roogle";
    rev = version;
    sha256 = "sha256-oeQwRcDn4X/CL+O4APmGv9T19c9oD5tCBRz4K41K1Zg=";
  };

  cargoHash = "sha256-lmRo6Q67hJ3hv0jQt6epiNOckRv0rA0a0DNEKIdDoUE=";

  meta = with lib; {
    description = "Rust API search engine which allows you to search functions by names and type signatures";
    mainProgram = "roogle";
    homepage = "https://github.com/hkmatsumoto/roogle";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
