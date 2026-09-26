{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-chef";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-chef";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YZulUoet6GHLQ4Zlf4DGkS9e9SdB1g3Ua/KQRCcQgYg=";
  };

  vendorHash = "sha256-CQDfUi3wBEh7D7bawmEmRRpKCPXdFpneaIcLwMcZGOY=";

  meta = {
    description = "Packer plugin for Chef";
    homepage = "https://github.com/hashicorp/packer-plugin-chef";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
