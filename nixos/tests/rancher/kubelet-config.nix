# A test that sets extra kubelet configuration and enables graceful node shutdown
import ../make-test-python.nix (
  {
    pkgs,
    lib,
    rancherDistro,
    rancherPackage,
    serviceName,
    disabledComponents,
    coreImages,
    vmResources,
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
    name = "${rancherPackage.name}-kubelet-config";
    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          kubectl
          jq
        ];
        environment.sessionVariables.KUBECONFIG = "/etc/rancher/${rancherDistro}/${rancherDistro}.yaml";

        virtualisation = vmResources;

        services.${rancherDistro} = {
          enable = true;
          package = rancherPackage;
          disable = disabledComponents;
          images = coreImages;
          inherit nodeName;
          gracefulNodeShutdown = {
            enable = true;
            inherit shutdownGracePeriod shutdownGracePeriodCriticalPods;
          };
          extraKubeletConfig = {
            inherit podsPerCore memoryThrottlingFactor containerLogMaxSize;
          };
        };
      };

    testScript = # python
      ''
        import json

        start_all()
        machine.wait_for_unit("${serviceName}")
        # wait until the node is ready
        machine.wait_until_succeeds(r"""kubectl get node ${nodeName} -ojson | jq -e '.status.conditions[] | select(.type == "Ready") | .status == "True"'""")
        # test whether the kubelet registered an inhibitor lock
        machine.succeed("systemd-inhibit --list --no-legend | grep \"^kubelet.*shutdown\"")
        # run kubectl proxy in the background, close stdout through redirection to not wait for the command to finish
        machine.execute("kubectl proxy --address 127.0.0.1 --port=8001 >&2 &")
        machine.wait_until_succeeds("nc -z 127.0.0.1 8001")
        # get the kubeletconfig
        kubelet_config=json.loads(machine.succeed("curl http://127.0.0.1:8001/api/v1/nodes/${nodeName}/proxy/configz | jq '.kubeletconfig'"))

        with subtest("Kubelet config values are set correctly"):
          t.assertEqual(kubelet_config["shutdownGracePeriod"], "${shutdownGracePeriod}")
          t.assertEqual(kubelet_config["shutdownGracePeriodCriticalPods"], "${shutdownGracePeriodCriticalPods}")
          t.assertEqual(kubelet_config["podsPerCore"], ${toString podsPerCore})
          t.assertEqual(kubelet_config["memoryThrottlingFactor"], ${toString memoryThrottlingFactor})
          t.assertEqual(kubelet_config["containerLogMaxSize"],"${containerLogMaxSize}")
      '';

    meta.maintainers = lib.teams.k3s.members ++ pkgs.rke2.meta.maintainers;
  }
)
