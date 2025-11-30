{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "matchbox-server";
  version = "v0.11.0";

  src = fetchFromGitHub {
    owner = "poseidon";
    repo = "matchbox";
    rev = "${version}";
    hash = "sha256-u1VY+zEx2YToz+WxVFaUDzY7HM9OeokbR/FmzcR3UJ8=";
  };

  vendorHash = "sha256-sVC4xeQIcqAbKU4MOAtNicHcioYjdsleQwKWLstnjfk=";

  subPackages = [
    "cmd/matchbox"
  ];

  # Go linker flags (go tool link)
  # Omit symbol tables and debug info
  ldflags = [
    "-w -s -X github.com/poseidon/matchbox/matchbox/version.Version=${version}"
  ];

  # Disable cgo to produce a static binary
  env.CGO_ENABLED = 0;

  # Don't run Go tests
  doCheck = false;

  meta = with lib; {
    description = "Server to network boot and provision Fedora CoreOS and Flatcar Linux clusters";
    homepage = "https://matchbox.psdn.io/";
    changelog = "https://github.com/poseidon/matchbox/blob/main/CHANGES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ dghubble ];
    mainProgram = "matchbox";
  };
}
