{ lib
, stdenv
, buildNpmPackage
, nodejs_20
, fetchFromGitHub
, python3
, darwin
, nixosTests
}:

buildNpmPackage rec {
  pname = "bitwarden-cli";
  version = "2024.6.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "cli-v${version}";
    hash = "sha256-qiUUrs23WHE3+KFsWDknuDSA6M3Zwjz9Jdjq6mn5XkE=";
  };

  nodejs = nodejs_20;

  npmDepsHash = "sha256-Mgd15eFJtWoBqFFCsjmsnlNbcg5NDs1U7DlMkE0hIb8=";

  nativeBuildInputs = [
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.cctools
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
