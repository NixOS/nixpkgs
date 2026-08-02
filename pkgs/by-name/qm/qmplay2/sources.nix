{ fetchFromGitHub }:

{
  qmplay2 =
    let
      self = {
        pname = "qmplay2";
        version = "26.08.02";

        src = fetchFromGitHub {
          owner = "zaps166";
          repo = "QMPlay2";
          tag = self.version;
          hash = "sha256-5y39RylYa+dvgAtxg1fh4y8UOJwPoKRfmrc0gGwL7vk=";
        };
      };
    in
    self;

  vulkan-headers-qmplay2 =
    let
      self = {
        pname = "vulkan-headers";
        version = "1.4.358";

        src = fetchFromGitHub {
          owner = "KhronosGroup";
          repo = "Vulkan-Headers";
          tag = "v${self.version}";
          hash = "sha256-SrfDWSp7DmGHT+fM09gry9L4x6BDWxoUi3Qtbi1qg2I=";
        };
      };
    in
    self;

  qmvk = {
    pname = "qmvk";
    version = "0-unstable-2026-06-21";

    src = fetchFromGitHub {
      owner = "zaps166";
      repo = "QmVk";
      rev = "26ef419a3b91bc11856c714b3b932c62db098bf9";
      hash = "sha256-EaOGXYjon1brDQx+l7C2jvUkYgkW+D1qP52JPiMr3H0=";
    };
  };
}
