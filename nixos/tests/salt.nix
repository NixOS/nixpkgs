{ lib, ... }:
{
  name = "salt";
  meta.maintainers = [ lib.maintainers.h7x4 ];

  containers = {
    master = {
      services.salt.master = {
        enable = true;
        configuration.file_roots.base = [ "/etc/salt/srv" ];
      };

      environment.etc = {
        "salt/srv/top.sls".text = ''
          base:
            '*':
              - testfile
        '';
        "salt/srv/testfile.sls".text = ''
          /root/testfile.txt:
            file.managed:
              - contents: Hello from the Salt master!
        '';
      };

      networking.firewall.allowedTCPPorts = [
        4505
        4506
      ];
    };

    minion = {
      services.salt.minion = {
        enable = true;
        configuration.master = "master";
      };
    };
  };

  testScript = ''
    start_all()

    master.wait_for_unit("salt-master.service")
    minion.wait_for_unit("salt-minion.service")

    master.wait_until_succeeds("salt-key --list=pre | grep -qx minion")
    master.succeed("salt-key --accept=minion --yes")
    master.wait_until_succeeds("salt minion test.ping")

    minion.succeed("salt-call state.highstate")
    minion.succeed("grep -qx 'Hello from the Salt master!' /root/testfile.txt")
  '';
}
