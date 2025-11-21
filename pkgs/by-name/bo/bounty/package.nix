{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  libgit2,
  pkg-config,
}:

rustPlatform.buildRustPackage {
  pname = "bounty";
  version = "0.1.0-unstable-2025-02-15";

  src = fetchFromGitHub {
    owner = "ghbountybot";
    repo = "cli";
    rev = "452c7545e611e0648de661f7f9c6444c157a3945";
    hash = "sha256-0f+ad7mgFskESh9yW+Y53hCFmHmINyy1XgHyB14sK54=";
  };

  cargoHash = "sha256-dlfoA5bWtyHrsviPdFd6O47D/cglvhJzChOboyu1Io0=";

  doCheck = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    libgit2
  ];

  meta = {
    description = "CLI tool for bountybot.dev";
    homepage = "https://github.com/ghbountybot/cli";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ andrewgazelka ];
    mainProgram = "bounty";
  };
}
