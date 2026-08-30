{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  sqlite,
  versionCheckHook,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "bendsql";
  version = "0.34.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-TSHUts54DfgWMTHuCUzjRdDVx6QXpOm+5Lhli6rlnqQ=";
  };

  cargoHash = "sha256-ST2ybXxXMd5MRFaITEoFRw0/yx+dOkff6vVm3mW87A4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite ];

  env = {
    BENDSQL_BUILD_INFO = "nixpkgs";
    LIBSQLITE3_SYS_USE_PKG_CONFIG = "1";
  };

  postPatch = ''
    substituteInPlace build.rs \
      --replace-fail "BuildBuilder::default().build_timestamp(true).build()?" \
                     "BuildBuilder::default().build_timestamp(false).build()?"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "bendsql --version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Native command-line client for Databend";
    mainProgram = "bendsql";
    homepage = "https://github.com/databendlabs/bendsql";
    changelog = "https://github.com/databendlabs/bendsql/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mnixry ];
  };
})
