import ./make-test-python.nix ({ pkgs, ...} : {
  name = "smokeping";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ cransom ];
  };

  nodes = {
    sm =
      { ... }:
      {
        networking.domain = "example.com"; # FQDN: sm.example.com
        services.smokeping = {
          enable = true;
          mailHost = "127.0.0.2";
          probeConfig = ''
            + FPing
            binary = /run/wrappers/bin/fping
            offset = 0%
          '';
        };
      };
  };

  testScript = ''
    start_all()
    sm.wait_for_unit("smokeping")
    sm.wait_for_unit("nginx")
    sm.wait_for_file("/var/lib/smokeping/data/Local/LocalMachine.rrd")
    sm.succeed("curl -s -f localhost/smokeping.fcgi?target=Local")
    # Check that there's a helpful page without explicit path as well.
    sm.succeed("curl -s -f localhost")
    sm.succeed("ls /var/lib/smokeping/cache/Local/LocalMachine_mini.png")
    sm.succeed("ls /var/lib/smokeping/cache/index.html")

    # stop and start the service like nixos-rebuild would do
    # see https://github.com/NixOS/nixpkgs/issues/265953)
    sm.succeed("systemctl stop smokeping")
    sm.succeed("systemctl start smokeping")
    # ensure all services restarted properly
    sm.succeed("systemctl --failed | grep -q '0 loaded units listed'")
  '';
})
