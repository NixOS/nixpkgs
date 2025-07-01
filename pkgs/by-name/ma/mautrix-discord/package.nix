{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  nix-update-script,
  testers,
  mautrix-discord,
}:

buildGoModule rec {
  pname = "mautrix-discord";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "v${version}";
    hash = "sha256-ygnFZ1I8sPgpKwLK+Zr6ZUStGAH2egVDxS/pXmRqXYI=";
  };

  vendorHash = "sha256-S3MWJi77TXs7gjPt6O2ruSIUHpsrLPIHQz3rQam1Wsg=";

  ldflags = [
    "-s"
    "-w"
  ];

  buildInputs = [ olm ];

  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = mautrix-discord;
    };
  };

  meta = with lib; {
    description = "Matrix-Discord puppeting bridge";
    homepage = "https://github.com/mautrix/discord";
    changelog = "https://github.com/mautrix/discord/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      MoritzBoehme
      sumnerevans
    ];
    mainProgram = "mautrix-discord";
  };
}
