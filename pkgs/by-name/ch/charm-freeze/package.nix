{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm-freeze";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "freeze";
    rev = "v${version}";
    hash = "sha256-ItcdgQUPrz2hpWS6nDYfnZaCdfocR3QgJTQ4TXzPQOw=";
  };

  vendorHash = "sha256-01tTr5NSyg52KGspYh9Rw98uQld6U+31Fy7jnyBoPx8=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "A tool to generate images of code and terminal output";
    mainProgram = "freeze";
    homepage = "https://github.com/charmbracelet/freeze";
    changelog = "https://github.com/charmbracelet/freeze/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ caarlos0 maaslalani ];
  };
}
