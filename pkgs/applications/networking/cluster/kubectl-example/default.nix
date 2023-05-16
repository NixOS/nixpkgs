{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-example";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "seredot";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-YvB4l+7GLSyYWX2Fbk4gT2WLaQpNxeV0aHY3Pg+9LCM=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-7tqeIE6Ds8MrLH9k8cdzpeJP9pXVptduoEFE0zdrLlo=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "kubectl plugin for retrieving resource example YAMLs";
    homepage = "https://github.com/seredot/kubectl-example";
    changelog = "https://github.com/seredot/kubectl-example/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
  };
}
