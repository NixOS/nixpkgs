# A test that containerdConfigTemplate settings get written to containerd/config.toml
import ../make-test-python.nix (
  {
    pkgs,
    lib,
    rancherDistro,
    rancherPackage,
    serviceName,
    disabledComponents,
    ...
  }:
  let
    nodeName = "test";
  in
  {
    name = "${rancherPackage.name}-containerd-config";
    nodes.machine =
      { ... }:
      {
        environment.systemPackages = [ pkgs.jq ];
        # k3s uses enough resources the default vm fails.
        virtualisation.memorySize = 1536;
        virtualisation.diskSize = 4096;

        services.${rancherDistro} = {
          enable = true;
          package = rancherPackage;
          disable = disabledComponents;
          inherit nodeName;
          containerdConfigTemplate = ''
            # Base ${rancherDistro} config
            {{ template "base" . }}

            # MAGIC COMMENT
          '';
        };
      };

    testScript = # python
      ''
        start_all()
        machine.wait_for_unit("${serviceName}")
        # wait until the node is ready
        machine.wait_until_succeeds(r"""kubectl get node ${nodeName} -ojson | jq -e '.status.conditions[] | select(.type == "Ready") | .status == "True"'""")
        # test whether the config template file contains the magic comment
        out=machine.succeed("cat /var/lib/rancher/${rancherDistro}/agent/etc/containerd/config.toml.tmpl")
        t.assertIn("MAGIC COMMENT", out, "the containerd config template does not contain the magic comment")
        # test whether the config file contains the magic comment
        out=machine.succeed("cat /var/lib/rancher/${rancherDistro}/agent/etc/containerd/config.toml")
        t.assertIn("MAGIC COMMENT", out, "the containerd config does not contain the magic comment")
      '';

    meta.maintainers = lib.teams.k3s.members;
  }
)
