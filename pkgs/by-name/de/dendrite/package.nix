{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, nix-update-script
, nixosTests
, postgresql
, postgresqlTestHook
}:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.13.8";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    hash = "sha256-zUpZdG2cdZ95L70qLG2HaUlD+G66XTi4f1V4+ZZAh30=";
  };

  vendorHash = "sha256-rGOB1ikY3BgChvD1YZUF66g8P6gE29b/k9kxvHR0+WQ=";

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
    extraArgs = [ "--version-regex" "v(.+)" ];
  };

  meta = with lib; {
    homepage = "https://matrix-org.github.io/dendrite";
    description = "Second-generation Matrix homeserver written in Go";
    changelog = "https://github.com/matrix-org/dendrite/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
    platforms = platforms.unix;
  };
}
