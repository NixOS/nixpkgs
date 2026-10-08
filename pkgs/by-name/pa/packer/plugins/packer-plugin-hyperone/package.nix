{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-hyperone";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-hyperone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CusY70gsoDFA5K38QEzwCq/lCE8D72iDqNm/0u3kcv4=";
  };

  vendorHash = "sha256-l71v9ymLio4iHg1AKt6GHXkukmLGTDGXFoEaqf0i54E=";

  meta = {
    description = "Packer plugin for HyperOne";
    homepage = "https://github.com/hashicorp/packer-plugin-hyperone";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
