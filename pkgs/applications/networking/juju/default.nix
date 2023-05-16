{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
<<<<<<< HEAD
  version = "3.2.2";
=======
  version = "3.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
<<<<<<< HEAD
    sha256 = "sha256-ZmMOQCKQWtzB2O6CNZTRhhj7gkpRRXY9ILN2KdSQoWk=";
  };

  vendorHash = "sha256-rqf5nAXwcW6lm7sidEcxMqatT4KPju4Seo1/Awse5Zs=";
=======
    sha256 = "sha256-nleWdgIYmIltZKjjFl6axQd2fkL8UIXZRbATU96cdQ0=";
  };

  vendorHash = "sha256-b6C1FbVXHeJqG9Vh8dqqZ+94T42oRM9kVbDmLuOiPvA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Disable tests because it attempts to use a mongodb instance
  doCheck = false;

  subPackages = [
    "cmd/juju"
  ];

  meta = with lib; {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
  };
}
