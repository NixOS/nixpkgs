{ lib
, stdenv
, buildNpmPackage
, nodejs_20
, fetchFromGitHub
, python311
, cctools
, nixosTests
, xcbuild
}:

buildNpmPackage rec {
  pname = "bitwarden-cli";
  version = "2024.6.1";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "cli-v${version}";
    hash = "sha256-LKeJKA4/Vd80y48RdZTUh10bY38AoQ5G5oK6S77fSJI=";
  };

  nodejs = nodejs_20;

  npmDepsHash = "sha256-rwzyKaCW3LAOqw6BEu8DLS0Ad5hB6cH1OnjWzbSEgVI=";

  nativeBuildInputs = [
    python311
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
