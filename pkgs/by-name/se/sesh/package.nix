{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "sesh";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "v${version}";
    hash = "sha256-ndHi7GSdc+BJ7eYRt9ZE+eabZbFlYKJ9AqTY6Xs53QI=";
  };

  vendorHash = "sha256-3wNp1meUoUFPa2CEgKjuWcu4I6sxta3FPFvCb9QMQhQ=";

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
