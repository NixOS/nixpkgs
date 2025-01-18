{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  jid,
}:

buildGoModule rec {
  pname = "jid";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "simeji";
    repo = "jid";
    rev = "v${version}";
    hash = "sha256-fZzEbVNGsDNQ/FhII+meQvKeyrgxn3wtFW8VfNmJz5U=";
  };

  vendorHash = "sha256-Lq8ouTjPsGhqDwrCMpqkSU7FEGszYwAkwl92vAEZ68w=";

  patches = [
    # Run go mod tidy
    ./go-mod.patch
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = jid;
    version = "v${version}";
  };

  meta = with lib; {
    description = "Command-line tool to incrementally drill down JSON";
    mainProgram = "jid";
    homepage = "https://github.com/simeji/jid";
    license = licenses.mit;
    maintainers = with maintainers; [ stesie ];
  };
}
