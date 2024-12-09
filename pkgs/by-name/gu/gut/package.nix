{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "gut";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "julien040";
    repo = "gut";
    rev = version;
    hash = "sha256-pjjeA0Nwc5M3LwxZLpBPnFqXJX0b6KDaj4YCPuGoUuU=";
  };

  vendorHash = "sha256-G9oDMHLmdv/vQfofTqKAf21xaGp+lvW+sedLmaj+A5A=";

  ldflags = [ "-s" "-w" "-X github.com/julien040/gut/src/telemetry.gutVersion=${version}" ];

  # Depends on `/home` existing
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Alternative git CLI";
    homepage = "https://gut-cli.dev";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "gut";
  };
}
