{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,

  foundationdb,
  stalwart-migrate,
  cacert,

  withFoundationDb ? false,
  withEnterprise ? true,
  withTests ? false,
}:
let
  ossVari = !withEnterprise;
  fdbVari = withFoundationDb && withEnterprise;
  variant = lib.optionalString ossVari "oss" + lib.optionalString fdbVari "fdb";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stalwart-migrate" + lib.optionalString (variant != "") "-${variant}";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "stalwart-migrate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RXUDW99WMZu20VYNkc5W9WwaPhgQB2dIX5mIGuZSI1Y=";
  };

  cargoHash = "sha256-F/Dif4LBhXIDK+fnq5HDx1qEV2zm09PlH2W372O5l+c=";

  __structuredAttrs = true;

  env = {
    STRESS_SEEDS = 5;
  }
  // lib.optionalAttrs withFoundationDb {
    FDB_CLIENT_LIB_PATH = "${lib.getLib foundationdb}/lib";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "rocks"
    "sqlite"
    "postgres"
    "mysql"
    "s3"
    "azure"
    "redis"
  ]
  ++ lib.optionals withFoundationDb [ "foundation" ]
  ++ lib.optionals withEnterprise [ "enterprise" ];

  cargoBuildFlags = [
    "-p"
    "migrate"
  ];

  doCheck = withTests;

  nativeCheckInputs = [
    cacert
  ];

  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru = {
    oss = stalwart-migrate.override {
      withEnterprise = false;
    };
    fdb = stalwart-migrate.override {
      withFoundationDb = true;
      withEnterprise = true;
    };
    tests = {
      "build-with-tests" = stalwart-migrate.override {
        inherit withEnterprise withFoundationDb;
        withTests = true;
      };
    };
  };

  meta = {
    description =
      "Tool to assist with migration from v0.16.27 to v1"
      + lib.optionalString (variant != "") " (${variant})";

    longDescription = ''
      `stalwart-migrate` moves the data of a Stalwart Mail and Collaboration Server v0.16.27 deployment
      to Stalwart v1, and can move it back again if the upgrade has to be reverted.

      `${if variant == "" then "default" else variant}` variant is built with the following features:
    ''
    + lib.strings.concatMapStrings (feat: "* " + feat + "\n") finalAttrs.buildFeatures;
    homepage = "https://github.com/stalwartlabs/stalwart-migrate";
    changelog = "https://github.com/stalwartlabs/stalwart-migrate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.OR [
      lib.licenses.agpl3Only
      lib.licenses.stalwart
    ];
    mainProgram = "stalwart-migrate";
    maintainers = with lib.maintainers; [
      debtquity
    ];
  }
  # 20261026: fdb variant tests fail due to current version of fdb in
  #  nixpkgs is <=7.4.0 (7.3.68). Output from e2e tests:
  #   "The version of FoundationDB binding requested '740' is not
  #    supported by the installed FoundationDB C library. Maximum
  #    supported version by the local library is 730 ..."
  // lib.optionalAttrs fdbVari {
    problems.broken.message = ''
      The fdb variant requires foundationdb version >=7.4.0. It's possible to build
      this variant but would need to overlay a prerelease version of foundationdb.
    '';
  };
})
