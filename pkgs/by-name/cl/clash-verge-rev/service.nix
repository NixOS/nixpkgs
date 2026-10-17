{
  lib,
  rustPlatform,
  fetchFromGitHub,
  meta,
  mihomo,
  procps,
  replaceVars,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clash-verge-service-ipc";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service-ipc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O8tQ4geASXt4xDNVjbmKCI2WxegzR3VWEZuOUZMCdLo=";
  };

  patches = [
    (replaceVars ./patch-service-directory.patch {
      mihomo = lib.getExe mihomo;
    })
  ];

  cargoHash = "sha256-so3Y+G31xupCX+nKBBLuB82dEAiCSI4fvJB5hLRsdbA=";

  buildFeatures = [
    "standalone"
  ];

  nativeCheckInputs = [
    procps
  ];
  # build test helper binaries for tests
  preCheck = ''
    cargo build --features=standalone,test
  '';
  checkFeatures = [
    "standalone"
    "test"
    "client"
  ];
  inherit meta;
})
