{ buildGoModule
, fetchFromGitHub
, lib
, nix-update-script
}:

buildGoModule rec {
  pname = "gut";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "julien040";
    repo = "gut";
    rev = version;
    hash = "sha256-zi0Hqf9fuZIh0GlP1Qf3dq5z1+eR1mO+Ybagehyif9g=";
  };

  vendorHash = "sha256-hsZEWGA+sHZJ3S15OkfLOIALmHJeYVxxg3vKgTGtiJE=";

  ldflags = [ "-s" "-w" "-X github.com/julien040/gut/src/telemetry.gutVersion=${version}" ];

  # Depends on `/home` existing
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An easy-to-use git client for Windows, macOS, and Linux";
    homepage = "https://github.com/slackhq/go-audit";
    maintainers = [ lib.maintainers.paveloom ];
    license = [ lib.licenses.mit ];
  };
}
