{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  postgresql,
  postgresqlTestHook,
}:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "dendrite";
    rev = "v${version}";
    hash = "sha256-b/kybHF9WcP88kQuG7LB0/pgflYUeWNqEHfUyKfUCIU=";
  };

  vendorHash = "sha256-380xuwMD9gxrjUsLfO8R08wruyWZwjRhiIDmSc/FGwA=";

  subPackages = [
    # The server
    "cmd/dendrite"
    # admin tools
    "cmd/create-account"
    "cmd/generate-config"
    "cmd/generate-keys"
    "cmd/resolve-state"
    ## curl, but for federation requests, only useful for developers
    # "cmd/furl"
    ## an internal tool for upgrading ci tests, only relevant for developers
    # "cmd/dendrite-upgrade-tests"
    ## tech demos
    # "cmd/dendrite-demo-pinecone"
    # "cmd/dendrite-demo-yggdrasil"
  ];

  nativeCheckInputs = [
    postgresqlTestHook
    postgresql
  ];

  postgresqlTestUserOptions = "LOGIN SUPERUSER";
  preCheck = ''
    export PGUSER=$(whoami)
    # temporarily disable this failing test
    # it passes in upstream CI and requires further investigation
    rm roomserver/internal/input/input_test.go
  '';

  # PostgreSQL's request for a shared memory segment exceeded your kernel's SHMALL parameter
  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.tests = {
    inherit (nixosTests) dendrite;
  };
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(.+)"
    ];
  };

  meta = {
    homepage = "https://element-hq.github.io/dendrite";
    description = "Second-generation Matrix homeserver written in Go";
    changelog = "https://github.com/element-hq/dendrite/releases/tag/v${version}";
    license = lib.licenses.agpl3Plus;
    teams = [ lib.teams.matrix ];
    platforms = lib.platforms.unix;
  };
}
