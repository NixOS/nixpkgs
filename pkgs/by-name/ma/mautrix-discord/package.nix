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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "v${version}";
    hash = "sha256-KRfbxPblOL4JznnGx9Jj5XXEWEKzan5xWvAwYmP7yGc=";
  };

  vendorHash = "sha256-8SW2q4Svfe8X9qwzYBa5HhHyQZDsPJqig/V1/Wp+avo=";

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
