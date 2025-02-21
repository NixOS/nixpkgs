{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "jinja-lsp";
  version = "0.1.84";

  src = fetchFromGitHub {
    owner = "uros-5";
    repo = "jinja-lsp";
    tag = "v${version}";
    hash = "sha256-VgdrPpYY2RC+6JKaPYcd0wI381TPaE/NBx7uDI8Ud5g=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7h2iY6tpUoOGnLmhI8SJUSLlM9CadgtiWEFHFr1gURs=";

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
