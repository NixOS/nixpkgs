{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  sqlite,
  zstd,
  versionCheckHook,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "bendsql";
  version = "0.34.3";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-AGApCnVfUcoK4md/6PyD6W9jK0j3HTdQJB7b51g/HhM=";
  };

  cargoHash = "sha256-n0U7PE7ixX+3WPWzbYgwkZb65T0BS31N9JQffdgHOJY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    sqlite
    zstd
  ];

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
