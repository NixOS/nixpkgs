{
  stdenv,
  fetchFromGitLab,
  lib,
  darwin,
  nettle,
  nix-update-script,
  rustPlatform,
  pkg-config,
  pcsclite,
  openssl,
  gnupg,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "openpgp-ca";
  version = "0.13.1";

  src = fetchFromGitLab {
    owner = "openpgp-ca";
    repo = "openpgp-ca";
    rev = "openpgp-ca/v${version}";
    hash = "sha256-6K7H/d82Ge+JQykqTXAD43wlGTQl+U9D/vA+CNz4rfM=";
  };

  cargoHash = "sha256-PrbepiaQbfGEqJRIcOMR6ED3BLopZLhospTzWRUoW0A=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  nativeCheckInputs = [
    gnupg
  ];

  buildInputs =
    [
      openssl
      sqlite
      pcsclite
      nettle
    ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        PCSC
        Security
        SystemConfiguration
      ]
    );

  # Most tests rely on gnupg being able to write to /run/user
  # gnupg refuses to respect the XDG_RUNTIME_DIR variable, so we skip the tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Tool for managing OpenPGP keys within organizations";
    homepage = "https://openpgp-ca.org/";
    changelog = "https://openpgp-ca.org/doc/changelog/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ cherrykitten ];
    mainProgram = "oca";
  };
}
