{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "kube-review";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "anderseknert";
    repo = "kube-review";
    tag = "v${version}";
    hash = "sha256-0wDapaV1e6QNZWeHG86t12iu1yW1LW6mnpdWIrwvBFk=";
  };

  vendorHash = "sha256-lzhjIX+67S+68erlJNHVXMKgRFUUyG+ymZEKVKRRpRc=";
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
