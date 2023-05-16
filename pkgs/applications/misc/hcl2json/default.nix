{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hcl2json";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-XdPRata9B8cK58eyAKxEBBwKAum+z0yoGgUGSkmhXfw=";
  };

  vendorHash = "sha256-F7G8K0tfXyLHQgqd2PE9eRXlhkFgijAO9LKKj9mvvwc=";
=======
    sha256 = "sha256-kmg483HidFL9mP6jXisLN5VR0dd0xzPXSwqTR8tOCrM=";
  };

  vendorHash = "sha256-ejbCY5S/aeY5Sp+5A20y5kUDY0yxgnMUxtr3UPvtic0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert hcl2 to json";
    homepage = "https://github.com/tmccombs/hcl2json";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
