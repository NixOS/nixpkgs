{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "sesh";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "v${version}";
    hash = "sha256-Dla43xI6y7J9M18IloSm1uDeHAhfslU56Z0Q3nVzjIk=";
  };

  vendorHash = "sha256-3wNp1meUoUFPa2CEgKjuWcu4I6sxta3FPFvCb9QMQhQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Smart session manager for the terminal";
    homepage = "https://github.com/joshmedeski/sesh";
    changelog = "https://github.com/joshmedeski/sesh/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gwg313 ];
    mainProgram = "sesh";
  };
}
