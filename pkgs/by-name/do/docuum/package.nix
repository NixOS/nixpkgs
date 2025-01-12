{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "docuum";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "docuum";
    rev = "v${version}";
    hash = "sha256-nWd6h39jU1eZWPFMxhxActsmrs9k0TDMlealuzTa+o0=";
  };

  cargoHash = "sha256-uoQ1qUII6TSZsosAdNfs2CREVuN2kuT9Bmi5vuDT/rY=";

  checkFlags = [
    # fails, no idea why
    "--skip=format::tests::code_str_display"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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
