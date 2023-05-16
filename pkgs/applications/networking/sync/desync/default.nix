<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "desync";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "desync";
    rev = "refs/tags/v${version}";
    hash = "sha256-FeZhLY0fUUNNqa6qZZnh2z06+NgcAI6gY8LRR4xI5sM=";
  };

  vendorHash = "sha256-1RuqlDU809mtGn0gOFH/AW6HJo1cQqt8spiLp3/FpcI=";
=======
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "desync";
  version = "0.9.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "folbricht";
    repo = "desync";
    sha256 = "sha256-vyW5zR6Dw860LUj7sXFgwzU1AZDoPMoQ4G0xsK4L6+w=";
  };

  vendorSha256 = "sha256-RMM/WFIUg2Je3yAgshif3Nkhm8G3bh6EhHCHTAvMXUc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # nix builder doesn't have access to test data; tests fail for reasons unrelated to binary being bad.
  doCheck = false;

  meta = with lib; {
    description = "Content-addressed binary distribution system";
    longDescription = "An alternate implementation of the casync protocol and storage mechanism with a focus on production-readiness";
    homepage = "https://github.com/folbricht/desync";
<<<<<<< HEAD
    changelog = "https://github.com/folbricht/desync/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ chaduffy ];
=======
    license = licenses.bsd3;
    platforms = platforms.unix; # *may* work on Windows, but varies between releases.
    maintainers = [ maintainers.chaduffy ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
