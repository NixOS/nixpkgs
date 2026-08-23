{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-scaffolding";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-scaffolding";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PcPOAhUQBCFfa10Itysvyrr1v62+z5OYjQzLC/0wktg=";
  };

  vendorHash = "sha256-hYvMwLPKD5af1sh0lqJppGoHXhWfFh3I9vUU+4PqTlA=";

  meta = {
    description = "Packer plugin for scaffolding";
    homepage = "https://github.com/hashicorp/packer-plugin-scaffolding";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
