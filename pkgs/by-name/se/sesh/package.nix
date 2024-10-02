{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "sesh";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "v${version}";
    hash = "sha256-62w4I49ahXC4IHy0i/V4tArCqrg2Rch6f+IM/YoFQh8=";
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
