# A test that containerdConfigTemplate settings get written to containerd/config.toml
import ../make-test-python.nix (
  { lib, k3s, ... }:
  let
    nodeName = "test";
  in
  {
    name = "${k3s.name}-containerd-config";
    nodes.machine =
      { ... }:
      {
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
          containerdConfigTemplate = ''
            # Base K3s config
            {{ template "base" . }}

            # MAGIC COMMENT
          '';
        };
      };

    testScript = ''
      start_all()
      machine.wait_for_unit("k3s")
      # wait until the node is ready
      machine.wait_until_succeeds(r"""kubectl wait --for='jsonpath={.status.conditions[?(@.type=="Ready")].status}=True' nodes/${nodeName}""")
      # test whether the config template file contains the magic comment
      out=machine.succeed("cat /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl")
      assert "MAGIC COMMENT" in out, "the containerd config template does not contain the magic comment"
      # test whether the config file contains the magic comment
      out=machine.succeed("cat /var/lib/rancher/k3s/agent/etc/containerd/config.toml")
      assert "MAGIC COMMENT" in out, "the containerd config does not contain the magic comment"
    '';

    meta.maintainers = lib.teams.k3s.members;
  }
)
