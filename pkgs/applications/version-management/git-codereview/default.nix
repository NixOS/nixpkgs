{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "git-codereview";
<<<<<<< HEAD
  version = "1.5.0";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "golang";
    repo = "review";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Dy7gHT6WmZ1TjA5s+VmOUkaRvrA9v7mWQSLPscgBHgY=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-vh2XFzvGEMutlaHKNhpuYdlnNl49zoNPkLYNUA1lWwc=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  nativeCheckInputs = [ git ];

  meta = with lib; {
    description = "Manage the code review process for Git changes using a Gerrit server";
    homepage = "https://golang.org/x/review/git-codereview";
    license = licenses.bsd3;
    maintainers = [ maintainers.edef ];
  };
}
