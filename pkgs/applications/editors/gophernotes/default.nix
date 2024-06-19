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

  vendorHash = "sha256-iIBqx52fD12R+7MSjQNihMYYtZ9vPAdJndOG4YJVhy4=";

  meta = with lib; {
    description = "Go kernel for Jupyter notebooks";
    homepage = "https://github.com/gopherdata/gophernotes";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
    mainProgram = "gophernotes";
  };
}
