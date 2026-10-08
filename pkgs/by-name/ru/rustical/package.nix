{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  cacert,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustical";
  version = "0.16.0";
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "lennart-k";
    repo = "rustical";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0IW3sS0CFqcSgiP+3w+SVFerbHX10gIs/I+blKFW4cE=";
  };

  cargoHash = "sha256-zTFDM3nMy5C26Zaz/7eFEe4dSwVXQ7TqN4z+MNRp7XE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  passthru.tests = {
    inherit (nixosTests) rustical;
  };

  meta = {
    description = "Yet another calendar server aiming to be simple, fast and passwordless";
    homepage = "https://github.com/lennart-k/rustical";
    changelog = "https://github.com/lennart-k/rustical/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ PopeRigby ];
    mainProgram = "rustical";
  };
})
