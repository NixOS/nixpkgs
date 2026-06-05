{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "multus-cni";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "k8snetworkplumbingwg";
    repo = "multus-cni";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Q6ACXOv1E3Ouki4ksdlUZFbWcDgo9xbCiTfEiVG5l18=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=gopkg.in/k8snetworkplumbingwg/multus-cni.v3/pkg/multus.version=${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/multus-daemon"
    "cmd/multus-shim"
    "cmd/multus"
    "cmd/thin_entrypoint"
  ];

  vendorHash = null;

  doCheck = true;

  meta = {
    description = "Multus CNI is a container network interface (CNI) plugin for Kubernetes that enables attaching multiple network interfaces to pods";
    homepage = "https://github.com/k8snetworkplumbingwg/multus-cni";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      onixie
      kashw2
    ];
    mainProgram = "multus";
  };
})
