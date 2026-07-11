{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-docker";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-docker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h89FGwUQjTk81CYUe1xmKxSHr1t3wyBg9lHUTqmVym8=";
  };

  vendorHash = "sha256-mvyafYSLi/q7lWorfKc4Gc4oM7yti3v/bLcVnNkH7ZY=";

  meta = {
    description = "Packer plugin for Docker";
    homepage = "https://github.com/hashicorp/packer-plugin-docker";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
