{ buildGoModule
, fetchFromGitHub
, lib
, nix-update-script
}:

buildGoModule rec {
  pname = "gut";
<<<<<<< HEAD
  version = "0.2.10";
=======
  version = "0.2.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "julien040";
    repo = "gut";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-y6GhLuTqOaxAQjDgqh1ivDwGhpYY0a6ZNDdE3Pox3is=";
  };

  vendorHash = "sha256-91iyAFD/RPEkMarKKVwJ4t92qosP2Db1aQ6dmNZNDwU=";

  ldflags = [ "-s" "-w" "-X github.com/julien040/gut/src/telemetry.gutVersion=${version}" ];

  # Depends on `/home` existing
=======
    sha256 = "sha256-qmp6QWmyharyTzUVXlX/oJZWbeyegX/u8/vzi/pTSaA=";
  };

  vendorSha256 = "sha256-E4jr+dskBdVXj/B5RW1AKyxxr+f/+ZW42OTO9XbCLuw=";

  ldflags = [ "-s" "-w" "-X github.com/julien040/gut/src/telemetry.gutVersion=${version}" ];

  # Checks if `/home` exists
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An easy-to-use git client for Windows, macOS, and Linux";
    homepage = "https://github.com/slackhq/go-audit";
    maintainers = [ lib.maintainers.paveloom ];
    license = [ lib.licenses.mit ];
  };
}
