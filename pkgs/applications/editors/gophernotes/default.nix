{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gophernotes";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "gopherdata";
    repo = "gophernotes";
    rev = "v${version}";
    sha256 = "sha256-cGlYgay/t6XIl0U9XvrHkqNxZ6BXtXi0TIANY1WdZ3Y=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-iIBqx52fD12R+7MSjQNihMYYtZ9vPAdJndOG4YJVhy4=";
=======
  vendorSha256 = "sha256-iIBqx52fD12R+7MSjQNihMYYtZ9vPAdJndOG4YJVhy4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Go kernel for Jupyter notebooks";
    homepage = "https://github.com/gopherdata/gophernotes";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
