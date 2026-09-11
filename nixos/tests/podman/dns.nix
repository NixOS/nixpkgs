{ pkgs, lib, ... }:
{
  name = "podman-dns";

  meta = {
    maintainers = lib.teams.podman.members;
  };

  nodes = {
    dns_iptables = {
      virtualisation.podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
        dns.interfaces = [ "custom" ];
      };

      networking.firewall.backend = "iptables";
    };
    dns_nftables = {
      virtualisation.podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
        dns.interfaces = [ "custom" ];
      };

      networking.firewall.backend = "nftables";
      networking.nftables.enable = true;
    };
    dns_firewalld = {
      virtualisation.podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      networking.firewall.backend = "firewalld";
      services.firewalld.enable = true;
      networking.nftables.enable = true;
    };
  };

  testScript = ''
    start_all()

    def test_podman(node, network = None, interface = None):
        network_arg = ""
        if network is not None:
            network_arg = f"--network={network}"
            if interface is None:
                node.succeed(f"podman network create {network}")
            else:
                node.succeed(f"podman network create {network} --interface-name {interface}")

        node.succeed(
            f"podman run -d {network_arg} --name=webserver -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin -w ${pkgs.writeTextDir "index.html" "<h1>Testing</h1>"} scratchimg ${pkgs.python3}/bin/python -m http.server 8000"
        )
        node.succeed("podman ps | grep webserver")
        node.wait_until_succeeds(
            f"podman run --rm {network_arg} --name=client -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg ${pkgs.curl}/bin/curl http://webserver:8000 | grep Testing"
        )
        node.succeed("podman stop webserver")
        node.succeed("podman rm webserver")

        if network is not None:
            node.succeed(f"podman network rm {network}")

    for node in machines:
        node.succeed("tar cv --files-from /dev/null | podman import - scratchimg")

        with subtest(f"aardvark-dns on node {node.name} in the default network"):
            test_podman(node, None)

        with subtest(f"aardvark-dns on node {node.name} in a custom network"):
            test_podman(node, "custom", "custom")

        with subtest(f"aardvark-dns on node {node.name} in an auto-named network"):
            test_podman(node, "auto", None)
  '';
}
