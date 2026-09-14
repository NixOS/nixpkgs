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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openpgp-ca";
  version = "0.14.1";

  src = fetchFromGitLab {
    owner = "openpgp-ca";
    repo = "openpgp-ca";
    rev = "openpgp-ca/v${finalAttrs.version}";
    hash = "sha256-JbT/YB1FBYjibRMTQhT7l7ZmtjVnmrcTEQZpJL++Whc=";
  };

  cargoHash = "sha256-LT2GZrz0fspYuM/NwhM4dbV2votxSou20l4TbIg2D3A=";

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

  meta = {
    description = "Tool for managing OpenPGP keys within organizations";
    homepage = "https://openpgp-ca.org/";
    changelog = "https://openpgp-ca.org/doc/changelog/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ cherrykitten ];
    mainProgram = "oca";
  };
})
