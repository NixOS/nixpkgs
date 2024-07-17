{ lib
, stdenv
, buildNpmPackage
, nodejs_20
, fetchFromGitHub
, python311
, darwin
, nixosTests
, xcbuild
}:

buildNpmPackage rec {
  pname = "bitwarden-cli";
  version = "2024.7.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "cli-v${version}";
    hash = "sha256-FH7++E+kc86lksHjTbVFU0mP0ZB2xb6ZCojdyNm1iWU=";
  };

  nodejs = nodejs_20;

  npmDepsHash = "sha256-F2iqTWgK+5ts2wd5NLsuyMZp1FnsbJmSjT3lJzV9PUo=";

  nativeBuildInputs = [
    python311
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.cctools
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
