{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  nix-update-script,
  testers,
  mautrix-gmessages,
}:

buildGoModule rec {
  pname = "mautrix-gmessages";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "gmessages";
    tag = "v${version}";
    hash = "sha256-FNjFGO/4j3kLo79oU5fsYA2/yhc9cAsAGIAQ5OJ2VPE=";
  };

  vendorHash = "sha256-QZ16R5i0I7uvQCDpa9/0Fh3jP6TEiheenRnRUXHvYIQ=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.Tag=${version}"
  ];

  buildInputs = [ olm ];

  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = mautrix-gmessages; };
  };

  meta = with lib; {
    description = "Matrix-Google Messages puppeting bridge";
    homepage = "https://github.com/mautrix/gmessages";
    changelog = "https://github.com/mautrix/gmessages/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ sumnerevans ];
    mainProgram = "mautrix-gmessages";
  };
}
