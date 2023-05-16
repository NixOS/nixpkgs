{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "kondo";
<<<<<<< HEAD
  version = "0.7";
=======
  version = "0.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tbillington";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-m00zRNnryty96+pmZ2/ZFk61vy7b0yiWpomWzAHUAMk=";
  };

  cargoHash = "sha256-hG4bvcGYNwdNX9Wsdw30i3a3Ttxud+quNZpolgVKXQE=";
=======
    sha256 = "sha256-f0eRM4U2FwMGjmQKb3tjX2TRv1hN//FkoA2h6WmFOQk=";
  };

  cargoHash = "sha256-DouQN9Lo/CoqZZD3HuO1+Xzvc2yL5l157TeAi+bmfrE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Save disk space by cleaning unneeded files from software projects";
    homepage = "https://github.com/tbillington/kondo";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
