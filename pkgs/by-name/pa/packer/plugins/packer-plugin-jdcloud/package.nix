{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-jdcloud";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-jdcloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mYU/Gkb2P3OK4f7UP4UfxMadXe+nJ1q44U0ygEcnuuA=";
  };

  vendorHash = "sha256-+I4P7ILupygb3YrV/Z11PYYnmj0jMNBpo4nfOBqhOEM=";

  meta = {
    description = "Packer plugin for JDCloud";
    homepage = "https://github.com/hashicorp/packer-plugin-jdcloud";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
