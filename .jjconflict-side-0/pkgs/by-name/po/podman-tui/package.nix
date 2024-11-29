{ lib, stdenv, fetchFromGitHub, buildGoModule, testers, podman-tui }:

buildGoModule rec {
  pname = "podman-tui";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-tui";
    rev = "v${version}";
    hash = "sha256-IINxDP0ajQdqbHTjeUeFqPbLTSCTl9gEhPxUWOe6zQs=";
  };

  vendorHash = null;

  CGO_ENABLED = 0;

  tags = [ "containers_image_openpgp" "remote" ]
    ++ lib.optional stdenv.hostPlatform.isDarwin "darwin";

  ldflags = [ "-s" "-w" ];

  preCheck = ''
    export USER="$(whoami)"
    export HOME="$(mktemp -d)"
  '';

  checkFlags =
    let
      skippedTests = [
        # Disable flaky tests
        "TestDialogs"
        "TestVoldialogs"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.tests.version = testers.testVersion {
    package = podman-tui;
    command = "HOME=$(mktemp -d) podman-tui version";
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/containers/podman-tui";
    description = "Podman Terminal UI";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "podman-tui";
  };
}
