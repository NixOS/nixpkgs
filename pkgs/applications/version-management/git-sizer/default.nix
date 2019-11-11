{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "git-sizer";
  version = "1.3.0";

  goPackagePath = "github.com/github/git-sizer";

  src = fetchFromGitHub {
    owner = "github";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kmyvai5xfalm56ywa6mhdvvjnacdzwcyz28bw0pz9a4gyf1mgvh";
  };

  meta = with lib; {
    description = "Compute various size metrics for a Git repository";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.all;
  };
}
