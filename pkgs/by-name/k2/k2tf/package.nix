{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "k2tf";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "sl1pm4t";
    repo = "k2tf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LoYlX2kAfzI0GMUbBtvuOinDzvoHABKEaGhipe16FeA=";
  };

  proxyVendor = true;
  vendorHash = "sha256-h8ph8K/4luTUCkx5X1iakTubF651HblGDN4G1EtSKeE=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=v${finalAttrs.version}"
  ];

  meta = {
    description = "Kubernetes YAML to Terraform HCL converter";
    mainProgram = "k2tf";
    homepage = "https://github.com/sl1pm4t/k2tf";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.flokli ];
  };
})
