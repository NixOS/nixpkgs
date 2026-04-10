{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  aws-lc,
  sqlite,
  cacert,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustical";
  version = "0.16.6";
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "lennart-k";
    repo = "rustical";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dSnjxZE74uJBLlCBj3yq8phKAgoKDhiL84xvX91Vvd0=";
  };

  cargoHash = "sha256-8/PJG5F1yNyme/24rG/N3d3OSldAMOOFTaipTQyfpPo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    aws-lc
    sqlite
  ];

  env = {
    AWS_LC_SYS_USE_SYSTEM = true;
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
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
