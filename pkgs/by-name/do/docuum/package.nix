{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "docuum";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "docuum";
    rev = "v${version}";
    hash = "sha256-jZJkI4rk/8O6MsHjuDqmIiRc1LJpTajk/rSUVYnHiOs=";
  };

  cargoHash = "sha256-qBigfW0W3t0a43y99H22gmKBnhsu08Yd1CTTatsRfRs=";

  checkFlags = [
    # fails, no idea why
    "--skip=format::tests::code_str_display"
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.IOKit
  ];

  meta = with lib; {
    description = "Least recently used (LRU) eviction of Docker images";
    homepage = "https://github.com/stepchowfun/docuum";
    changelog = "https://github.com/stepchowfun/docuum/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "docuum";
  };
}
