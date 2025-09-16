{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  nix-update-script,
  testers,
  mautrix-gmessages,
  # This option enables the use of an experimental pure-Go implementation of the
  # Olm protocol instead of libolm for end-to-end encryption. Using goolm is not
  # recommended by the mautrix developers, but they are interested in people
  # trying it out in non-production-critical environments and reporting any
  # issues they run into.
  withGoolm ? false,
}:

buildGoModule rec {
  pname = "mautrix-gmessages";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "gmessages";
    tag = "v${version}";
    hash = "sha256-mcWvNRHRdgcw6ualaaJmUjHOrbOJfufyaHfdp20eoaY=";
  };

  vendorHash = "sha256-nIKRFdJsJrlmncvkXSL3agqTEqlmnEbp/3HZUfYVXpI=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.Tag=${version}"
  ];

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

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
