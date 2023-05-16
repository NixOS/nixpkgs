{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "lls";
<<<<<<< HEAD
  version = "0.2.0";
=======
  version = "0.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jcaesar";
    repo = "lls";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-FtRPRR+/R3JTEI90mAEHFyhqloAbNEdR3jkquKa9Ahw=";
  };

  cargoSha256 = "sha256-yjRbg/GzCs5d3zXL22j5U9c4BlOcRHyggHCovj4fMIs=";
=======
    hash = "sha256-Aq0MGhzSoJCkM0Wt/r5JSOz96LyRSgSryD7+m4aFZEA=";
  };

  cargoSha256 = "sha256-WY4MnPNDWFEzFOehm7TqCL05Ea6n93f8VWBTOuqjBAg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Tool to list listening sockets";
    license = licenses.mit;
    maintainers = [ maintainers.k900 ];
    platforms = platforms.linux;
    homepage = "https://github.com/jcaesar/lls";
  };
}
