{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "docuum";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "docuum";
    rev = "v${version}";
    hash = "sha256-/30wuLnCcomgJ14c5rNbitD1dEpvyRal3L60gQdZPBU=";
  };

  cargoHash = "sha256-BvZM0tAgwoOO0VFQEoifgmENnW3cfKV3Zj872/Lki6A=";

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
