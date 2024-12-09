{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "klog-rs";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "tobifroe";
    repo = "klog";
    rev = version;
    hash = "sha256-E3oL6XAp9N0ptDTpGBd6pmg4DJx9GDJv3ZSbkc6at60=";
  };
  cargoHash = "sha256-S2F9oVPZH52luSsFUlQCLANPJudjJvecv8S6BBUnC78=";
  checkFlags = [
    # this integration test depends on a running kubernetes cluster
    "--skip=k8s::tests::test_get_pod_list"
    "--skip=k8s::tests::test_get_pod_list_for_resource"
  ];

  meta = {
    description = "Tool to tail logs of multiple Kubernetes pods simultaneously";
    homepage = "https://github.com/tobifroe/klog";
    changelog = "https://github.com/tobifroe/klog/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "klog";
    maintainers = with lib.maintainers; [ tobifroe ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
