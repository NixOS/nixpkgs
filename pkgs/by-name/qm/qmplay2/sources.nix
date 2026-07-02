{ fetchFromGitHub }:

{
  qmplay2 =
    let
      self = {
        pname = "qmplay2";
        version = "25.09.11";

        src = fetchFromGitHub {
          owner = "zaps166";
          repo = "QMPlay2";
          tag = self.version;
          hash = "sha256-1F6VOTMJZ64PlIVSWoYzNz4LVmn5pEcUq+IfstYDwYo=";
        };
      };
    in
    self;

  vulkan-headers-qmplay2 =
    let
      self = {
        pname = "vulkan-headers";
        version = "1.4.317";

        src = fetchFromGitHub {
          owner = "KhronosGroup";
          repo = "Vulkan-Headers";
          tag = "v${self.version}";
          hash = "sha256-ezNthwKsnXehQfrQh0zTk6Zrz3JgdqjYu68abYUWIik=";
        };
      };
    in
    self;

  qmvk = {
    pname = "qmvk";
    version = "0-unstable-2025-09-02";

    src = fetchFromGitHub {
      owner = "zaps166";
      repo = "QmVk";
      rev = "0225dc851afaf39be2b92f91d4316e866f4b6133";
      hash = "sha256-W2102+X+gE/9ghdAwWBeWYmSkSdp6lLPx4IKaQpLANI=";
    };
  };
}
