{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "coinlive";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "mayeranalytics";
    repo = "coinlive";
    rev = "refs/tags/v${version}";
    hash = "sha256-llw97jjfPsDd4nYi6lb9ug6sApPoD54WlzpJswvdbRs=";
  };

  cargoHash = "sha256-T1TgwnohUDvfpn6GXNP4xJGHM3aenMK+ORxE3z3PPA4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  checkFlags = [
    # Test requires network access
    "--skip=utils::test_get_infos"
  ];

  doInstallCheck = true;

  meta = with lib; {
    description = "Live cryptocurrency prices CLI";
    homepage = "https://github.com/mayeranalytics/coinlive";
    changelog = "https://github.com/mayeranalytics/coinlive/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "coinlive";
  };
}
