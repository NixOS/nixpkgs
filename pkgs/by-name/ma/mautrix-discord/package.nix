{ lib
, buildGoModule
, fetchFromGitHub
, olm
, nix-update-script
, testers
, mautrix-discord
}:

buildGoModule rec {
  pname = "mautrix-discord";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "v${version}";
    hash = "sha256-N6CepP+P63TIKKi6FQLJEuV5hFtiv1CcBM+1Y/QPZrI=";
  };

  vendorHash = "sha256-QdH98NA5Y9YKkvL8Gq8ChgvHFOyOBFXDDulxwql6v5c=";

  ldflags = [ "-s" "-w" ];

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
    maintainers = with maintainers; [ MoritzBoehme ];
    mainProgram = "mautrix-discord";
  };
}
