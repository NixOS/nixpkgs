# A test that sets extra kubelet configuration and enables graceful node shutdown
import ../make-test-python.nix (
  {
    pkgs,
    lib,
    k3s,
    ...
  }:
  let
    nodeName = "test";
    shutdownGracePeriod = "1m13s";
    shutdownGracePeriodCriticalPods = "13s";
    podsPerCore = 3;
    memoryThrottlingFactor = 0.69;
    containerLogMaxSize = "5Mi";
  in
  {
    name = "${k3s.name}-kubelet-config";
    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.jq ];

        # k3s uses enough resources the default vm fails.
        virtualisation.memorySize = 1536;
        virtualisation.diskSize = 4096;

        services.k3s = {
          enable = true;
          package = k3s;
          # Slightly reduce resource usage
          extraFlags = [
            "--disable coredns"
            "--disable local-storage"
            "--disable metrics-server"
            "--disable servicelb"
            "--disable traefik"
            "--node-name ${nodeName}"
          ];
          gracefulNodeShutdown = {
            enable = true;
            inherit shutdownGracePeriod shutdownGracePeriodCriticalPods;
          };
          extraKubeletConfig = {
            inherit podsPerCore memoryThrottlingFactor containerLogMaxSize;
          };
        };
      };

    testScript = ''
      import json

      start_all()
      machine.wait_for_unit("k3s")
      # wait until the node is ready
      machine.wait_until_succeeds(r"""kubectl wait --for='jsonpath={.status.conditions[?(@.type=="Ready")].status}=True' nodes/${nodeName}""")
      # test whether the kubelet registered an inhibitor lock
      machine.succeed("systemd-inhibit --list --no-legend | grep \"kubelet.*k3s-server.*shutdown\"")
      # run kubectl proxy in the background, close stdout through redirection to not wait for the command to finish
      machine.execute("kubectl proxy --address 127.0.0.1 --port=8001 >&2 &")
      machine.wait_until_succeeds("nc -z 127.0.0.1 8001")
      # get the kubeletconfig
      kubelet_config=json.loads(machine.succeed("curl http://127.0.0.1:8001/api/v1/nodes/${nodeName}/proxy/configz | jq '.kubeletconfig'"))

      with subtest("Kubelet config values are set correctly"):
        assert kubelet_config["shutdownGracePeriod"] == "${shutdownGracePeriod}", \
          f"unexpected value for shutdownGracePeriod: {kubelet_config["shutdownGracePeriod"]}"
        assert kubelet_config["shutdownGracePeriodCriticalPods"] == "${shutdownGracePeriodCriticalPods}", \
          f"unexpected value for shutdownGracePeriodCriticalPods: {kubelet_config["shutdownGracePeriodCriticalPods"]}"
        assert kubelet_config["podsPerCore"] == ${toString podsPerCore}, \
          f"unexpected value for podsPerCore: {kubelet_config["podsPerCore"]}"
        assert kubelet_config["memoryThrottlingFactor"] == ${toString memoryThrottlingFactor}, \
          f"unexpected value for memoryThrottlingFactor: {kubelet_config["memoryThrottlingFactor"]}"
        assert kubelet_config["containerLogMaxSize"] == "${containerLogMaxSize}", \
          f"unexpected value for containerLogMaxSize: {kubelet_config["containerLogMaxSize"]}"
    '';

    meta.maintainers = lib.teams.k3s.members;
  }
)
