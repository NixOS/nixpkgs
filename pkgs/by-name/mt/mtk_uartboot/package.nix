{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "mtk-uartboot";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "981213";
    repo = "mtk_uartboot";
    rev = "refs/v${version}";
    hash = "sha256-mwwm2TVBfOEqvQIP0Vl4Q2SkcZxX1JP7rShmjaY+pWE=";
  };

  cargoHash = "sha256-At+HkvHcn6kAkSxBqFlaxUTZ7Xuy2lARMFQ2i6uybSk=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];

  meta = with lib; {
    description = "third-party tool to load and execute binaries over UART for Mediatek SoCs";
    homepage = "https://github.com/981213/mtk_uartboot";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "mtk_uartboot";
  };
}
