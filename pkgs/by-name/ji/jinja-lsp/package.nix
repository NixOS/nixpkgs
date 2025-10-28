{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "jinja-lsp";
  version = "0.1.89";

  src = fetchFromGitHub {
    owner = "uros-5";
    repo = "jinja-lsp";
    tag = "v${version}";
    hash = "sha256-K+7HS1dtDtHNMIseXopWzkFM3wC5b/sfYeHI3vxw74Q=";
  };

  cargoHash = "sha256-TxpQ5kGGjEXNSzLdcwVmzuD189xcX1ndYRdRvLTlIQw=";

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
