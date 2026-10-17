# Tests that containerd configuration (both template versions), kubelet configuration, and graceful
# node shutdown are configured correctly
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
  name = "${rancherPackage.name}-configuration";
  interactive.sshBackdoor.enable = true;

  nodes.machine =
    { ... }:
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
        containerdConfigTemplate = ''
          # Base ${rancherDistro} config
          {{ template "base" . }}

          # MAGIC COMMENT
        '';
        gracefulNodeShutdown = {
          enable = true;
          inherit shutdownGracePeriod shutdownGracePeriodCriticalPods;
        };
        extraKubeletConfig = {
          inherit podsPerCore memoryThrottlingFactor containerLogMaxSize;
        };
      };

      specialisation.containerd-v3.configuration = {
        services.${rancherDistro}.containerdConfigTemplateV3 = ''
          # Base ${rancherDistro} config
          {{ template "base" . }}

          # MAGIC COMMENT V3
        '';
      };
    };

  testScript = # python
    ''
      import json

      machine.wait_for_unit("${serviceName}")
      # wait until the node is ready
      machine.wait_until_succeeds(r"""kubectl get node ${nodeName} -ojson | jq -e '.status.conditions[] | select(.type == "Ready") | .status == "True"'""")

      with subtest("Inhibitor lock is registered"):
        machine.succeed("systemd-inhibit --list --no-legend | grep \"^kubelet.*shutdown\"")

      with subtest("Containerd config contains magic comment"):
        out=machine.succeed("cat /var/lib/rancher/${rancherDistro}/agent/etc/containerd/config.toml.tmpl")
        t.assertIn("MAGIC COMMENT", out, "the containerd config template does not contain the magic comment")
        # config file contains the magic comment
        out=machine.succeed("cat /var/lib/rancher/${rancherDistro}/agent/etc/containerd/config.toml")
        t.assertIn("MAGIC COMMENT", out, "the containerd config does not contain the magic comment")

      # run kubectl proxy in the background, close stdout through redirection to not wait for the command to finish
      machine.execute("kubectl proxy --address 127.0.0.1 --port=8001 >&2 &")
      machine.wait_until_succeeds("nc -z 127.0.0.1 8001")

      with subtest("Kubelet config values are set correctly"):
        kubelet_config=json.loads(machine.succeed("curl http://127.0.0.1:8001/api/v1/nodes/${nodeName}/proxy/configz | jq '.kubeletconfig'"))
        t.assertEqual(kubelet_config["shutdownGracePeriod"], "${shutdownGracePeriod}")
        t.assertEqual(kubelet_config["shutdownGracePeriodCriticalPods"], "${shutdownGracePeriodCriticalPods}")
        t.assertEqual(kubelet_config["podsPerCore"], ${toString podsPerCore})
        t.assertEqual(kubelet_config["memoryThrottlingFactor"], ${toString memoryThrottlingFactor})
        t.assertEqual(kubelet_config["containerLogMaxSize"],"${containerLogMaxSize}")

      with subtest("Containerd version 3 config template takes precedence"):
        machine.succeed("/run/booted-system/specialisation/containerd-v3/bin/switch-to-configuration test")
        machine.succeed("systemctl restart ${serviceName}")
        machine.wait_for_unit("${serviceName}")
        out=machine.succeed("cat /var/lib/rancher/${rancherDistro}/agent/etc/containerd/config-v3.toml.tmpl")
        t.assertIn("MAGIC COMMENT V3", out, "the containerd version 3 config template does not contain the magic comment")
        # the rendered config is the version 3 format and contains the magic comment
        machine.wait_until_succeeds("grep -q 'MAGIC COMMENT V3' /var/lib/rancher/${rancherDistro}/agent/etc/containerd/config.toml")
        out=machine.succeed("cat /var/lib/rancher/${rancherDistro}/agent/etc/containerd/config.toml")
        t.assertIn("version = 3", out, "the containerd config is not in the version 3 format")
    '';

  meta.maintainers = lib.teams.k3s.members ++ pkgs.rke2.meta.maintainers;
}
