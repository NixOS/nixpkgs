{ lib, buildGoModule, fetchFromGitHub, testers, odo }:

buildGoModule rec {
  pname = "odo";
<<<<<<< HEAD
  version = "3.14.0";
=======
  version = "3.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "redhat-developer";
    repo = "odo";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-d6C+nOz60CPnEsSf74+WBTaeIXGKtysVELg0+dXM1cU=";
=======
    sha256 = "sha256-J8Oiw7/jPwIoPh8erL7auSiQCRzvY7i4COPmtI3qPXY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  buildPhase = ''
    make bin
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a odo $out/bin
  '';

  passthru.tests.version = testers.testVersion {
    package = odo;
    command = "odo version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Developer-focused CLI for OpenShift and Kubernetes";
    license = licenses.asl20;
    homepage = "https://odo.dev";
    changelog = "https://github.com/redhat-developer/odo/releases/v${version}";
    maintainers = with maintainers; [ stehessel ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
