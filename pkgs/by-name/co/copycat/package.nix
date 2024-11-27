{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "ccat";
  version = "002";

  src = fetchFromGitHub {
    owner = "DeeKahy";
    repo = "CopyCat";
    rev = "refs/tags/${version}";
    hash = "sha256-0pqC6fxuvqOPuO10Em63tFguc3VJNnniPCHM6TcFDN0=";
  };

  cargoHash = "sha256-oNX1MUpOjRG02FHOU7zpktLAYKu/1+R2d96jC/VA0co=";

  buildInputs = lib.optionals (stdenv.hostPlatform.isDarwin) [
    darwin.apple_sdk_11_0.frameworks.AppKit
  ];

  meta = {
    description = "Utility to copy project tree contents to clipboard";
    homepage = "https://github.com/DeeKahy/CopyCat";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.deekahy ];
    mainProgram = "ccat";
  };
}
