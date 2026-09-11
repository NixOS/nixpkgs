{
  lib,
  mkPulumiPackage,
}:
mkPulumiPackage rec {
  owner = "pulumiverse";
  repo = "pulumi-talos";
  version = "0.7.1";
  rev = "v${version}"; # TODO: add support for `tag`
  hash = "sha256-mk56p7vle61NdRKEaC8v0Eh9aJiilwdaDMwVvLaVRIM=";
  vendorHash = "sha256-1xAIb7ZSsTqlVBpgFHc3RdQkNDngDT7A6tu7gEiGKjY=";
  cmdGen = "pulumi-tfgen-talos";
  cmdRes = "pulumi-resource-talos";
  extraLdflags = [
    "-X=github.com/${owner}/${repo}/provider/pkg/version.Version=${version}"
  ];
  pythonArgs.pname = "pulumiverse_talos";
  meta = {
    description = "Talos Linux resource package, providing IaC configuration of Talos k8s clusters";
    mainProgram = cmdRes;
    homepage = "https://www.pulumi.com/registry/packages/talos/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      nicoo
    ];
  };
}
