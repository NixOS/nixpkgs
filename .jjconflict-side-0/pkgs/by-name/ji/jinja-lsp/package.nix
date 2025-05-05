{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "jinja-lsp";
  version = "0.1.85";

  src = fetchFromGitHub {
    owner = "uros-5";
    repo = "jinja-lsp";
    tag = "v${version}";
    hash = "sha256-/4A9IiSeskRKblcZIpsMgZsqYE6eBSeyHPpO/owCGD8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-14zMp2Z2GG4IC2DWzbzv07GAph4q6pHFJTyy67jisXg=";

  cargoBuildFlags = [
    "-p"
    "jinja-lsp"
  ];

  meta = {
    description = "Language server implementation for jinja2";
    homepage = "https://github.com/uros-5/jinja-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamjhf ];
    mainProgram = "jinja-lsp";
  };
}
