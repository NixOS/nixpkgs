{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "klog-rs";
  version = "0.6.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tobifroe";
    repo = "klog";
    tag = finalAttrs.version;
    hash = "sha256-9NYtT4psGaWBVpwprpAdzEaWrmDRRnI1UDVD3Quzj6g=";
  };

  cargoHash = "sha256-sDjNJAOFW+0wRN9CCDZRj1q0juczugLibst7ys/mERc=";

  checkFlags = map (t: "--skip=${t}") [
    # this integration test depends on a running kubernetes cluster
    "k8s::tests::test_get_pod_list"
    "k8s::tests::test_get_pod_list_for_resource"
    "tests::test_active_pods_tracking"
    "tests::test_pod_manager_clone"
    "tests::test_pod_manager_creation"
    "tests::test_refresh_interval_zero_disables_refresh"
    "tests::test_start_pod_logs_spawns_task"
  ];

  meta = {
    description = "Tool to tail logs of multiple Kubernetes pods simultaneously";
    homepage = "https://github.com/tobifroe/klog";
    changelog = "https://github.com/tobifroe/klog/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "klog";
    maintainers = with lib.maintainers; [ tobifroe ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
