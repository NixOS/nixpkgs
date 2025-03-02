{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "sesh";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "v${version}";
    hash = "sha256-YFvUYacuvyzNXwY+y9kI4tPlrlojDuZpR7VaTGdVqb8=";
  };

  vendorHash = "sha256-3wNp1meUoUFPa2CEgKjuWcu4I6sxta3FPFvCb9QMQhQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  meta = {
    changelog = "https://github.com/joshmedeski/sesh/releases/tag/${src.rev}";
    description = "Smart session manager for the terminal";
    homepage = "https://github.com/joshmedeski/sesh";
    license = lib.licenses.mit;
    mainProgram = "sesh";
    maintainers = with lib.maintainers; [ gwg313 ];
  };
}
