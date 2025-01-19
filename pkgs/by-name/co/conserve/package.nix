{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "conserve";
  version = "24.8.0";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "conserve";
    rev = "v${version}";
    hash = "sha256-rdZTx0wFFtWt3EcpvWHY6m+8TEHEj53vhVpdRp5wbos=";
  };

  cargoHash = "sha256-IP9x3n5RdI+TKOhMBWEfw9P2CROcC0SmEsmMVaXjiDE=";

  buildInputs = lib.optionals (stdenv.hostPlatform.isDarwin) [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # expected to panic if unix user has no secondary group,
    # which is the case in the nix sandbox
    "--skip=test_fixtures::test::arbitrary_secondary_group_is_found"
    "--skip=chgrp_reported_as_changed"
  ];

  meta = {
    description = "Robust portable backup tool in Rust";
    homepage = "https://github.com/sourcefrog/conserve";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "conserve";
  };
}
