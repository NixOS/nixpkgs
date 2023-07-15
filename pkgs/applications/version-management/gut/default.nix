{ buildGoModule
, fetchFromGitHub
, lib
, nix-update-script
}:

buildGoModule rec {
  pname = "gut";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "julien040";
    repo = "gut";
    rev = version;
    hash = "sha256-y6GhLuTqOaxAQjDgqh1ivDwGhpYY0a6ZNDdE3Pox3is=";
  };

  vendorHash = "sha256-91iyAFD/RPEkMarKKVwJ4t92qosP2Db1aQ6dmNZNDwU=";

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
