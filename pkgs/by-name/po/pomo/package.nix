{ lib
, buildGoModule
, fetchFromGitHub
,
}:

buildGoModule rec {
  pname = "pomo";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Bahaaio";
    repo = "pomo";
    rev = "v${version}";
    hash = "sha256-gQ7bHQGaQPujpOwVdcwKgiYQjUECi/Pjt5LKwa1v1J8="; # fill in
  };

  vendorHash = "sha256-kbTYq4Xc86bcmNMhInq1rwYTbGRmu2TEXT2e7bqT5YY="; # fill in from `nix-build -A pomo`

  # tests are fast; keep them unless they fail in CI
  # doCheck = false;

  meta = with lib; {
    description = "Customizable TUI Pomodoro timer with ASCII art, progress bar, notifications, and stats";
    homepage = "https://github.com/Bahaaio/pomo";
    license = licenses.mit;
    maintainers = with maintainers; [
      bahaaio
      mugaizzo
    ];
    mainProgram = "pomo";
    # platforms = platforms.unix;
  };
}
