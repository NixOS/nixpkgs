{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "sesh";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "v${version}";
    hash = "sha256-oOr2jJAJuddyIPp9z7ottHFUDSpSyc5+PiNYyVD6Alg=";
  };

  vendorHash = "sha256-a45P6yt93l0CnL5mrOotQmE/1r0unjoToXqSJ+spimg=";

  ldflags = [ "-s" "-w" ];

  meta = {
    description = "Smart session manager for the terminal";
    homepage = "https://github.com/joshmedeski/sesh";
    changelog = "https://github.com/joshmedeski/sesh/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gwg313 ];
    mainProgram = "sesh";
  };
}
