{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "irccat";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "irccloud";
    repo = "irccat";
    rev = "v${version}";
    hash = "sha256-fr5x1usviJPbc4t5SpIVgV9Q6071XG8eYtyeyraddts=";
  };

  vendorHash = "sha256-IRXyM000ZDiLPHX20lXlx00tkCzBe5PqvdgXAvm0EAw=";

  meta = with lib; {
    homepage = "https://github.com/irccloud/irccat";
    description = "Send events to IRC channels from scripts and other applications";
    mainProgram = "irccat";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl3Only;
  };
}
