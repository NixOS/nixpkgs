{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "fakecloud";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "faiscadev";
    repo = "fakecloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0XgamS2ReW1GCxX0s8grhFDWDCyY6GDmPr82Lg42urA=";
  };

  cargoHash = "sha256-ROd/Us0H0KnD/oeorGScoqR74BtXqC1Xfb+fxXQWhKM=";

  # Conformance tests require a running fakecloud instance
  doCheck = false;

  meta = {
    description = "Local AWS cloud emulator for integration testing and local development";
    longDescription = ''
      fakecloud is a free, open-source local AWS emulator. It runs as a single
      binary with no account or auth token required, accepting connections at
      http://localhost:4566. It supports 22 AWS services with real end-to-end
      integrations (e.g. EventBridge → Step Functions, S3 → Lambda), stateful
      services (Lambda in Docker, RDS with real Postgres/MySQL/MariaDB,
      ElastiCache with real Redis/Valkey), and first-party test SDKs for
      TypeScript, Python, Go, PHP, Java, and Rust.
    '';
    homepage = "https://fakecloud.dev/";
    changelog = "https://github.com/faiscadev/fakecloud/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ kubukoz ];
    mainProgram = "fakecloud";
  };
})
