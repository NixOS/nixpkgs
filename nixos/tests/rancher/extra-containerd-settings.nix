# Tests that extraContainerdSettings generates a valid containerd config template
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
in
{
  name = "${rancherPackage.name}-extra-containerd-settings";
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
        extraContainerdSettings = {
          plugins."io.containerd.grpc.v1.cri".containerd.runtimes."test-runtime" = {
            runtime_type = "io.containerd.runc.v2";
          };
        };
      };
    };

  testScript = # python
    ''
      machine.wait_for_unit("${serviceName}")
      machine.wait_until_succeeds(r"""kubectl get node ${nodeName} -ojson | jq -e '.status.conditions[] | select(.type == "Ready") | .status == "True"'""")

      with subtest("Containerd config template contains base template and extra settings"):
        tmpl = machine.succeed("cat /var/lib/rancher/${rancherDistro}/agent/etc/containerd/config.toml.tmpl")
        t.assertIn('{{ template "base" . }}', tmpl, "the containerd config template does not contain the base template directive")
        t.assertIn("test-runtime", tmpl, "the containerd config template does not contain the extra runtime")

      with subtest("Containerd config is rendered correctly"):
        cfg = machine.succeed("cat /var/lib/rancher/${rancherDistro}/agent/etc/containerd/config.toml")
        t.assertIn("test-runtime", cfg, "the rendered containerd config does not contain the extra runtime")
    '';

  meta.maintainers = lib.teams.k3s.members ++ pkgs.rke2.meta.maintainers;
}
