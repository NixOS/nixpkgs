{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gophernotes";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "gopherdata";
    repo = "gophernotes";
    rev = "v${version}";
    sha256 = "sha256-LiYPos6Ic+se5bTTkvggmyxyS20uhgALkDU2LoXTci8=";
  };

  vendorSha256 = "sha256-wDMx3B47Vv87/3YEPX8/70Q5/REJ7IPvw8dA/viJiSY=";

  meta = with lib; {
    description = "Go kernel for Jupyter notebooks";
    homepage = "https://github.com/gopherdata/gophernotes";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
