{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gophernotes";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "gopherdata";
    repo = "gophernotes";
    rev = "v${version}";
    sha256 = "sha256-EEMKV+k5qcep4z7J5r1nSLxmb0fbfpJOPmz5bE91cd8=";
  };

  vendorSha256 = "sha256-Wy4HcPlrlYUjRQHhw+UPAa+Rn1FvJobWGxgFiJKJTAg=";

  meta = with lib; {
    description = "Go kernel for Jupyter notebooks";
    homepage = "https://github.com/gopherdata/gophernotes";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
