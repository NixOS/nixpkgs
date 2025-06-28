{ fetchFromGitHub }:

{
  qmplay2 =
    let
      self = {
        pname = "qmplay2";
        version = "25.01.19";

        src = fetchFromGitHub {
          owner = "zaps166";
          repo = "QMPlay2";
          tag = self.version;
          hash = "sha256-Of/zEQ6o2J/wXfAoY10IPtCaMaSk8ux8L6MrimeMWVA=";
          fetchSubmodules = true;
        };
      };
    in
    self;

  qmvk = {
    pname = "qmvk";
    version = "0-unstable-2025-06-05";

    src = fetchFromGitHub {
      owner = "zaps166";
      repo = "QmVk";
      rev = "754e6ca4b65433cb500a797e86d48d899d5a41c2";
      hash = "sha256-t4fGIfZhZE8ShQGa1zMJLpnvCEfCdCeAWOKwF4+nFSw=";
    };
  };
}
