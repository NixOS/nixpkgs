{
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage rec {
  pname = "restic-integrity";
  version = "1.2.2";

  src = fetchFromGitea {
    domain = "git.nwex.de";
    owner = "networkException";
    repo = "restic-integrity";
    rev = version;
    hash = "sha256-QiISJCxxJH8wQeH/klB48POn6W9juQmIMCLGzGSyl6w=";
  };

  cargoHash = "sha256-GxehJjDd0AHbEc8kPWyLXAOPbrPCT59LddAL1ydnT5g=";

  meta = with lib; {
    description = "A CLI tool to check the integrity of a restic repository without unlocking it";
    homepage = "https://git.nwex.de/networkException/restic-integrity";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ janik ];
    mainProgram = "restic-integrity";
  };
}
