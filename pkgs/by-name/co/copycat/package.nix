{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "ccat";
  version = "001";

  src = fetchFromGitHub {
    owner = "DeeKahy";
    repo = "CopyCat";
    rev = "refs/tags/${version}";
    hash = "sha256-zllxQifRMNEMa3RO5WKrwGAUf1xQg6YrQBzIHzy43F0=";
  };

  cargoHash = "sha256-LYVhvq5l+PCZXW+elWi3zZFxLekgPn+plo4dybbLK9g=";

  buildInputs = lib.optionals (stdenv.isDarwin) [
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
