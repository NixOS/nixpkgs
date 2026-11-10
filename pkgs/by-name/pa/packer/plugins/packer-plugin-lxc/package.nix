{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-lxc";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-lxc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I+rwq8IyqDjr549J5Yo2ZxB+UhiSPPM6wo+auJsLk9c=";
  };

  vendorHash = "sha256-KSsGU+Ss2+jkCqZExwuCy15r94Ykh7GRaBW46li213I=";

  meta = {
    description = "Packer plugin for LXC";
    homepage = "https://github.com/hashicorp/packer-plugin-lxc";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
