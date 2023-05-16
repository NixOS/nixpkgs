{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "swayest-workstyle";
<<<<<<< HEAD
  version = "1.3.5";
=======
  version = "1.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Lyr-7D1h";
    repo = "swayest_workstyle";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Dk6rAiz7PXUfyy9fWMtSVRjaWWl66n38gTNyWKqeqkU=";
  };

  cargoHash = "sha256-sLQPq3tyWq1TxxeFyg05qBt+KGI/vO0jLU7wJLiqcYA=";
=======
    sha256 = "sha256-N6z8xNT4vVULt8brOLlVAkJaqYnACMhoHJLGmyE7pZ0=";
  };

  cargoHash = "sha256-DiNhHuHUgJc9ea+EanaCybXzbrX2PEBdlR0h0zQQLn8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false; # No tests

  meta = with lib; {
    description = "Map sway workspace names to icons defined depending on the windows inside of the workspace";
    homepage = "https://github.com/Lyr-7D1h/swayest_workstyle";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ miangraham ];
    mainProgram = "sworkstyle";
  };
}
