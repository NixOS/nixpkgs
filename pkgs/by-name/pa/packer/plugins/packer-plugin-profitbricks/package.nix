{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-profitbricks";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-profitbricks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-52lZfGIRqhF175TF/VsLrkVlxUNc9qqFrNd7qKPB670=";
  };

  vendorHash = "sha256-/CbyMclRa6JElOBHpQlqEZohYzDFU1aLPQ1JFX94rBQ=";

  meta = {
    description = "Packer plugin for ProfitBricks";
    homepage = "https://github.com/hashicorp/packer-plugin-profitbricks";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
