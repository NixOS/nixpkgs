{ fetchFromGitHub }:

{
  qmplay2 =
    let
      self = {
        pname = "qmplay2";
        version = "25.06.27";

        src = fetchFromGitHub {
          owner = "zaps166";
          repo = "QMPlay2";
          tag = self.version;
          hash = "sha256-ouP9E9nk8T0EZr9D354hc/QKpyv7h3xpY1UCbo8Kw4k=";
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
