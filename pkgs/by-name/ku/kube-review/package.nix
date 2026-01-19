{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "kube-review";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "anderseknert";
    repo = "kube-review";
    tag = "v${version}";
    hash = "sha256-W+JF8MR+x6vova6hRw0omXXhT40qXmdZciAdt2bi6jM=";
  };

  vendorHash = "sha256-xHiHeSoiT/5h8pHTBTq1g/zJtnCbcUs+qMJ4vHjWzog=";
  ldflags = [
    "-X github.com/anderseknert/kube-review/cmd.version=v${version}"
  ];
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Create Kubernetes AdmissionReview requests from Kubernetes resource manifests";
    mainProgram = "kube-review";
    homepage = "https://github.com/anderseknert/kube-review";
    changelog = "https://github.com/anderseknert/kube-review/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ardubev16 ];
  };
}
