{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:
buildGoModule rec {
  pname = "codecrafters-cli";
  version = "29";

  src = fetchFromGitHub {
    owner = "codecrafters-io";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-h8W9MHKnJCktVn8ZL3agSD7PcihF3Ow/KEElSIPUPlM=";
  };

  vendorHash = "sha256-TQcxzfiqKeCQZUKLHnPjBa/0WsYJhER3fmr4cRGFknw=";

  nativeBuildInputs = [git];

  meta = with lib; {
    homepage = "https://github.com/codecrafters-io/cli";
    description = "Go based command line tool for codecrafters.io";
    license = licenses.mit;
    maintainers = [maintainers.amaihoefner];
    mainProgram = "codecrafters";
  };
}
