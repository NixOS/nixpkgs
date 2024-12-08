{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "canard";
  version = "0.0.2-unstable-2024-04-22";

  src = fetchFromGitHub {
    owner = "mrusme";
    repo = "canard";
    rev = "d3c37d11078574ca16b75475b3d08ffe351bc3c2";
    hash = "sha256-ICrTEaTYFAViORWvdj4uW2gLgxtWxRlhgu5sifgqGX0=";
  };

  vendorHash = "sha256-qcfPW7rz0v63QmQQceQltkCFNBUeQTxVerxDymv7SZo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mrusme/canard/main.VERSION=${version}"
  ];

  meta = {
    description = "Command line TUI client for the journalist RSS aggregator";
    homepage = "https://github.com/mrusme/canard";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "canard";
  };
}
