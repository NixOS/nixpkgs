{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
<<<<<<< HEAD
  version = "3.17.0";
=======
  version = "3.16.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-mXc3CVKh4pFAZVppvk5TTg6s6dOA2Gv+ROLNV37DAl4=";
  };

  vendorHash = "sha256-zn8q3HpyQWNsksYbqJcgnjOxaBVUr3dIYHk+FAalNxA=";
=======
    sha256 = "sha256-8hv68O4U9bPjqqtVOpmY3DwfeTGEZJGVkzIyYhS14aM=";
  };

  vendorHash = "sha256-aSpv4TGp0YLdk/RYEvfYswlEWnv8sy9iflXGGCcKPHs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
