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
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "gmessages";
    tag = "v${version}";
    hash = "sha256-s6d0fUH0md4oHWDGFDRR3SKbJBCH6qJIk4En6J53yIM=";
  };

  vendorHash = "sha256-d6UVKu9Al445JqwhPXSlQDs0hOTom56p+hVZN2C4S0M=";

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
