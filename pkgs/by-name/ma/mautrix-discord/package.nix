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
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "v${version}";
    hash = "sha256-Cz62UyWlIXGDmf0oki9opTbSl8H96g9kDzspNLzPcmc=";
  };

  vendorHash = "sha256-mCOnIKFt0sEB/vR94j8oo2feIsRcpQ4w9rEchR6lLG8=";

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

  meta = {
    description = "Matrix-Discord puppeting bridge";
    homepage = "https://github.com/mautrix/discord";
    changelog = "https://github.com/mautrix/discord/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      sumnerevans
    ];
    mainProgram = "mautrix-discord";
  };
}
