{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "skate";
<<<<<<< HEAD
  version = "0.2.2";
=======
  version = "0.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "skate";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Kum8IdgvRC75RLafCac0fkNn/VKvWFW48IK5tqLH/ME=";
  };

  proxyVendor = true;
  vendorHash = "sha256-xNM4qmpv+wcoiGrQ585N3VoKW6tio0cdHmUHRl2Pvio=";
=======
    sha256 = "sha256-7ieXQM1Z4q4f37YSEcGs7sBAZH+64OCrWp7uBP5VNqI=";
  };

  vendorSha256 = "sha256-/Q8T4/KaHglhdxMQg9v5H+mHZpuHFcLRAbh6CzaFJKU=";

  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "A personal multi-machine syncable key value store";
    homepage = "https://github.com/charmbracelet/skate";
<<<<<<< HEAD
    changelog = "https://github.com/charmbracelet/skate/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda penguwin ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
