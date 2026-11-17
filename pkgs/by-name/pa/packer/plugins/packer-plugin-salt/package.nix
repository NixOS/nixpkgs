{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-salt";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-salt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l9EY6GFYGh9ZlcX+TPB+5HQ+cXF16NxG0AVTfMzB8Eo=";
  };

  vendorHash = "sha256-6lL6i8eutpndkoN2h2hverwyXrTu8mxLuSYBoGwWgGU=";

  meta = {
    description = "Packer plugin for Salt";
    homepage = "https://github.com/hashicorp/packer-plugin-salt";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
