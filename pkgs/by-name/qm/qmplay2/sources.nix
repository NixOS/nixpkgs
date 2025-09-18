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
          hash = "sha256-+kDaRKwXOHnHje1RntC9y9xiTaMzs8SGMLVoJ+6IDNk=";
        };
      };
    in
    self;

  vulkan-headers-qmplay2 =
    let
      self = {
        pname = "vulkan-headers";
        version = "1.3.300";

        src = fetchFromGitHub {
          owner = "KhronosGroup";
          repo = "Vulkan-Headers";
          tag = "v${self.version}";
          hash = "sha256-6J+6yvbEQXLY+Wkf1pWKtUAZGbe5Tc01uVh3Wqmk2+8=";
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
