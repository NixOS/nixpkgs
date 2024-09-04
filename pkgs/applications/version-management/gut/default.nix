{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "gut";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "julien040";
    repo = "gut";
    rev = version;
    hash = "sha256-l7yjZEcpsnVisd93EqIug1n0k18m4tUmCQFXC6b63cg=";
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
