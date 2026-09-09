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
  version = "0.16.1";
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "lennart-k";
    repo = "rustical";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FvYW41/yuGHihI0bf+fq0JG/antsVYVXwhKlKiGNN10=";
  };

  cargoHash = "sha256-9Lu7NGLNSDQH2T5ikc3rc+/oc67N8QcniooXPyxKsOA=";

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
