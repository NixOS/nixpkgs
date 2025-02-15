{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "klog-rs";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "tobifroe";
    repo = "klog";
    rev = version;
    hash = "sha256-AlXyCDjs5xFqM0TmaBGfzvYn/ZDWAgBzLV/mDPQHflI=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-A9QhOFsjEXljsugakJ0s7XdAPF447JIFaQGfDGDVp1E=";
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
