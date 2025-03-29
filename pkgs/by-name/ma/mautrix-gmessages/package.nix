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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "gmessages";
    tag = "v${version}";
    hash = "sha256-qpqFWQ4ZhgzG7SG6phW6LnS52Ve1S+Ky6YtjzfBkBmE=";
  };

  vendorHash = "sha256-Ps9I8WtTtrc3gSMxt4XZ/IUipZL2+kbgNfbY2PYFoa8=";

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
