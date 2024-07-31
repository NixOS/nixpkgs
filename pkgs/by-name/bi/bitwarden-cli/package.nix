{ lib
, stdenv
, buildNpmPackage
, nodejs_20
, fetchFromGitHub
, python3
, cctools
, nixosTests
, xcbuild
}:

buildNpmPackage rec {
  pname = "bitwarden-cli";
  version = "2024.7.1";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "cli-v${version}";
    hash = "sha256-ZnqvqPR1Xuf6huhD5kWlnu4XOAWn7yte3qxgU/HPhiQ=";
  };

  nodejs = nodejs_20;

  npmDepsHash = "sha256-lWlAc0ITSp7WwxM09umBo6qeRzjq4pJdC0RDUrZwcHY=";

  nativeBuildInputs = [
    (python3.withPackages (ps: with ps; [ setuptools ]))
  ] ++ lib.optionals stdenv.isDarwin [
    cctools
    xcbuild.xcrun
  ];

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmBuildScript = "build:oss:prod";

  npmWorkspace = "apps/cli";

  npmFlags = [ "--legacy-peer-deps" ];

  passthru.tests = {
    vaultwarden = nixosTests.vaultwarden.sqlite;
  };

  meta = with lib; {
    changelog = "https://github.com/bitwarden/clients/releases/tag/${src.rev}";
    description = "Secure and free password manager for all of your devices";
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3Only;
    mainProgram = "bw";
    maintainers = with maintainers; [ dotlambda ];
  };
}
