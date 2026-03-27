{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ares-rs";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "bee-san";
    repo = "ares";
    tag = finalAttrs.version;
    hash = "sha256-IsIastLIrPknaJcH8sb0plPme+VGvo9DeDIisTD4sRM=";
  };

  cargoHash = "sha256-3L1LpmH96rYFB947sEhZcDK5g97zUgr2runjc1EYzZk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "Automated decoding of encrypted text without knowing the key or ciphers used";
    homepage = "https://github.com/bee-san/ares";
    changelog = "https://github.com/bee-san/Ares/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ares";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
