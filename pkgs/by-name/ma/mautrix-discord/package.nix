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
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "v${version}";
    hash = "sha256-q6FpeGWoeIVVeomKMHpXUntMWsMJMV73FDiBfbMQ6Oc=";
  };

  vendorHash = "sha256-6R5ryzjAAAI3YtTMlHjrLOXkid2kCe8+ZICnNUjtxaQ=";

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
