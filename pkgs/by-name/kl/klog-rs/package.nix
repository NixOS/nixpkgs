{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "klog-rs";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "tobifroe";
    repo = "klog";
    rev = version;
    hash = "sha256-t53HC5eBC587jyvJKxlG3B3Im7RM6bDcZfUO4npgGfM=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-HmKMxI94j0cLLAjmUJQhymop9qiH71Rm8dnVVs2VDF8=";
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
