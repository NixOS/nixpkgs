{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-hashicups";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-hashicups";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3SiJDvsSFd0FlEsl9s7kYfcPlJ8ooXY0ykkm3rAIdY0=";
  };

  vendorHash = "sha256-WwpyDVUz3zOx5KPG98Q3hwLVO0p8wAe7cIV/VjWEImY=";

  meta = {
    description = "Packer plugin for HashiCups";
    homepage = "https://github.com/hashicorp/packer-plugin-hashicups";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
