{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "jinja-lsp";
  version = "0.1.86";

  src = fetchFromGitHub {
    owner = "uros-5";
    repo = "jinja-lsp";
    tag = "v${version}";
    hash = "sha256-Cj09E0uQ/HFD5nU7QonKyFdsQyICgWOPyCNu1V0oFQw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-rzGe8XK/MRIvbJCF5Cx7Sm+wAK7SQx3gCCXSnWeJ+Xo=";

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
