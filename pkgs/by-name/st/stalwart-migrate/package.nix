{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,

  aws-lc,
  pkg-config,
  stalwart-migrate,
  cacert,
  sqlite,
  zstd,

  withEnterprise ? false,
  withTests ? false,
}:
let
  variant = lib.optionalString withEnterprise "enterprise";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stalwart-migrate" + lib.optionalString withEnterprise "-${variant}";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "stalwart-migrate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0K4nlQEPocrl612JN8T5nyDU9ddAG4X8J7D6vcU52dk=";
  };

  cargoHash = "sha256-AUws5yo7GqC0G7UHgylClVlcgbzC4JPXkqI0KmghHiI=";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    STRESS_SEEDS = 5;
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    aws-lc
    sqlite
    zstd
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
    tests = {
      "build-with-tests" = stalwart-migrate.override {
        inherit withEnterprise;
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

      `${if variant == "" then "oss" else variant}` variant is built with the following features:
    ''
    + lib.strings.concatMapStrings (feat: "* " + feat + "\n") finalAttrs.buildFeatures;
    homepage = "https://github.com/stalwartlabs/stalwart-migrate";
    changelog = "https://github.com/stalwartlabs/stalwart-migrate/releases/tag/${finalAttrs.src.tag}";
    license = [
      lib.licenses.agpl3Only
    ]
    ++ lib.optionals withEnterprise [
      lib.licenses.stalwart
    ];
    mainProgram = "stalwart-migrate";
    maintainers = with lib.maintainers; [
      debtquity
    ];
  };
})
