{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  openssl,
  sqlite,
  zlib,
  cacert,
  testers,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cashu-cdk";
  version = "0.18.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cashubtc";
    repo = "cdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TzMKmLZtuSnjL+tw/nEPMAIxIl3iGJT62fa0w9eG6Cw=";
  };

  cargoHash = "sha256-IkGOISP+/d3KMbZJJGmjn95yF8kHU5r+I3kNX0T1ppE=";

  cargoBuildFlags = [
    "--package=cdk-cli"
    "--package=cdk-mintd"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    openssl
    sqlite
    zlib
  ];

  nativeCheckInputs = [ cacert ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = "1";
    PROTOC = lib.getExe protobuf;
    PROTOC_INCLUDE = "${protobuf}/include";
  };

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      cdk-cli = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "cdk-cli --version";
      };
      cdk-mintd = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "cdk-mintd --version";
      };
    };
  };

  meta = {
    description = "Cashu wallet CLI and mint daemon";
    homepage = "https://github.com/cashubtc/cdk";
    changelog = "https://github.com/cashubtc/cdk/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ prusnak ];
    mainProgram = "cdk-cli";
  };
})
