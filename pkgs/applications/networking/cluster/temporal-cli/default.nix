{ lib, fetchFromGitHub, buildGoModule, testers, temporal-cli }:

buildGoModule rec {
  pname = "temporal-cli";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "tctl";
    rev = "v${version}";
    hash = "sha256-LcBKkx3mcDOrGT6yJx98CSgxbwskqGPWqOzHWOu6cig=";
  };

  vendorHash = "sha256-BUYEeC5zli++OxVFgECJGqJkbDwglLppSxgo+4AqOb0=";

  ldflags = [ "-s" "-w" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru.tests.version = testers.testVersion {
    package = temporal-cli;
    # the app writes a default config file at startup
    command = "HOME=$(mktemp -d) ${meta.mainProgram} --version";
  };

  meta = with lib; {
    description = "Temporal CLI";
    homepage = "https://temporal.io";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "tctl";
  };
}
