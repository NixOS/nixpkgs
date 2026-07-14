{ fetchFromGitHub }:

{
  qmplay2 =
    let
      self = {
        pname = "qmplay2";
        version = "26.06.27";

        src = fetchFromGitHub {
          owner = "zaps166";
          repo = "QMPlay2";
          tag = self.version;
          hash = "sha256-8PY6s74unLgwDFlyiHHCWrsatdI05obbREOICZoI+lU=";
        };
      };
    in
    self;

  vulkan-headers-qmplay2 =
    let
      self = {
        pname = "vulkan-headers";
        version = "1.4.350";

        src = fetchFromGitHub {
          owner = "KhronosGroup";
          repo = "Vulkan-Headers";
          tag = "v${self.version}";
          hash = "sha256-RcUVurC+Rc0MyWpQLaLVmdn7FZO1GWWzTZZAOwvKwb4=";
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
