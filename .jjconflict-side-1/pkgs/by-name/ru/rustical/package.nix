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
  version = "0.16.5";
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "lennart-k";
    repo = "rustical";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sQhZoS/Mv3nqf8rZpmbrqUknDf2PqpZhcxuo3CCcEnY=";
  };

  cargoHash = "sha256-1DEbF7zum1XbyZJSWCBT9/yc0QoaliWjOhO8rCCxqDM=";

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
