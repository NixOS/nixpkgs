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
  version = "2024.7.2";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "cli-v${version}";
    hash = "sha256-MqIznJe5GeRTJ+sgOJoTHAQaac0obuBDb63XxQeG1iY=";
  };

  nodejs = nodejs_20;

  npmDepsHash = "sha256-XDN92VPKTA9KeSg5CQXxhXyEARZBwpERZ3400xqwg7U=";

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
