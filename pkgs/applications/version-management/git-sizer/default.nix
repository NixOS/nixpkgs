{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "git-sizer";
  version = "1.0.0";

  goPackagePath = "github.com/github/git-sizer";

  src = fetchFromGitHub {
    owner = "github";
    repo = pname;
    rev = "v${version}";
    sha256 = "11rvqpsyl41ph0fgm62k5q2p33zgnwj1jd91rd4lkaarpcd1sg5h";
  };

  meta = with lib; {
    description = "Compute various size metrics for a Git repository";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.all;
  };
}
