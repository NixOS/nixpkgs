{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stc";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = pname;
<<<<<<< HEAD
    rev = version;
    sha256 = "sha256-g1zn/CBpLv0oNhp32njeNhhli8aTCECgh92+zn5v+4U=";
  };

  vendorHash = "sha256-0OsxCGCJT5k5bHXNSIL6QiJXj72bzYCZiI03gvHQuR8=";
=======
    rev = "${version}";
    sha256 = "sha256-g1zn/CBpLv0oNhp32njeNhhli8aTCECgh92+zn5v+4U=";
  };

  vendorSha256 = "sha256-0OsxCGCJT5k5bHXNSIL6QiJXj72bzYCZiI03gvHQuR8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Syncthing CLI Tool";
    homepage = "https://github.com/tenox7/stc";
    changelog = "https://github.com/tenox7/stc/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
