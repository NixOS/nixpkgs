{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mandelbrot-cli";
  version = "0-unstable-2025-07-16";

  src = fetchFromGitHub {
    owner = "IronstoneInnovation";
    repo = "mandelbrot_cli";
    rev = "36a43d4feace4ac346c6da78262278d4deb6bb94";
    hash = "sha256-RGv/B2Zi2hqHWPbo67vTlJIIci3a0tyIgD5+Tnf0yiY=";
  };

  cargoHash = "sha256-nOhg3nDWGA+0g499EnsX5TNwnZM2NcpqHiyQujOM3OI=";

  meta = {
    description = "A CLI for generating images of the Mandelbrot Set";
    homepage = "https://github.com/IronstoneInnovation/mandelbrot_cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "mandelbrot-cli";
  };
})
