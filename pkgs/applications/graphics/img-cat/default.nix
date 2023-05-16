{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "imgcat";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "trashhalo";
    repo = "imgcat";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-L2Yvp+UR6q45ctKsi0v45lKkSE7eJsUPvG7lpX8M6nQ=";
  };

  vendorHash = "sha256-4kF+LwVNBY770wHLLcVlAqPoy4SNhbp2TxdNWRiJL6Q=";
=======
    sha256 = "0x7a1izsbrbfph7wa9ny9r4a8lp6z15qpb6jf8wsxshiwnkjyrig";
  };

  vendorSha256 = "191gi4c5jk8p9xvbm1cdhk5yi8q2cp2jvjq1sgxqw1ad0lppwhg2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A tool to output images as RGB ANSI graphics on the terminal";
    homepage = "https://github.com/trashhalo/imgcat";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
