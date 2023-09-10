import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "systemd-as-dropin";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ aanderse ];
  };

  nodes.machine = { pkgs, lib, ... }: lib.mkMerge [
    {
      systemd.services."foo@" = {
        path = [ pkgs.hello ];
        serviceConfig.Type = "oneshot";
        scriptArgs = "%i";
        script = ''
          hello -g "Hello, $1!"
        '';
      };
    }

    {
      systemd.services."foo@bar" = {
        overrideStrategy = "asDropin";
      };
    }
  ];


  testScript = ''
    machine.wait_for_unit("multi-user.target")

    # Ensure PATH is not clobbered for dropin service units
    machine.succeed("systemctl start foo@bar.service")
    machine.succeed("systemctl show foo@bar.service | grep Environment | grep ${pkgs.hello}")
  '';
})
