{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ticker";
<<<<<<< HEAD
  version = "4.5.14";
=======
  version = "4.5.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-WpU0fxkdNqr8zF6eGOlbaV9dp6sZyNZ1J7Uq+yGBnUs=";
=======
    hash = "sha256-2CELRY6V7/6PcC5s4XjOqadxXc5SbS0vstqLEej3xnI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-c7wU9LLRlS9kOhE4yAiKAs/npQe8lvSwPcd+/D8o9rk=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/achannarasappa/ticker/cmd.Version=v${version}"
  ];

  # Tests require internet
  doCheck = false;

  meta = with lib; {
    description = "Terminal stock ticker with live updates and position tracking";
    homepage = "https://github.com/achannarasappa/ticker";
    changelog = "https://github.com/achannarasappa/ticker/releases/tag/v${version}";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ siraben sarcasticadmin ];
=======
    maintainers = with maintainers; [ siraben ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
