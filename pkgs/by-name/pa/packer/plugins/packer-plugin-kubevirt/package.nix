{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-kubevirt";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-kubevirt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h2XYo7b3+URK2f9zIe4snqW5q6jc4zWssBcOigLtS/g=";
  };

  vendorHash = "sha256-UT07PiFCr8UyADPbc5I/60/A1KbJ+lZEi23IsBKxueM=";

  meta = {
    description = "Packer plugin for KubeVirt";
    homepage = "https://github.com/hashicorp/packer-plugin-kubevirt";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
