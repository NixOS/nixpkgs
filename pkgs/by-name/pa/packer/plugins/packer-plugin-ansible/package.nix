{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-ansible";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-ansible";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1v1d7yAQOy9sE9F1G1uinKNOjddrsxdT9mywht8r14g=";
  };

  vendorHash = "sha256-s6xZHyDOGNxrGINN11AnM3fspi6gE4RpXocgUJkHScs=";

  meta = {
    description = "Packer plugin for Ansible";
    homepage = "https://github.com/hashicorp/packer-plugin-ansible";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
