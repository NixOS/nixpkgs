{
  fetchFromGitLab,
  lib,
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
  version = "0.14.0";

  src = fetchFromGitLab {
    owner = "openpgp-ca";
    repo = "openpgp-ca";
    rev = "openpgp-ca/v${version}";
    hash = "sha256-71SApct2yQV3ueWDlZv7ScK1s0nWWS57cPCvoMutlLA=";
  };

  cargoHash = "sha256-uftsBw8ZegnaoFel/wEqCMhVxiGR13jKbKqVSm+23T4=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  nativeCheckInputs = [
    gnupg
  ];

  buildInputs = [
    openssl
    sqlite
    pcsclite
    nettle
  ];

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
