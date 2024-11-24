import ./make-test-python.nix ({ pkgs, ... }:

let
  exampleScript = pkgs.writeTextFile {
    name = "example.sh";
    text = ''
      #! ${pkgs.runtimeShell} -e

      while true; do
          echo "Example script running" >&2
          ${pkgs.coreutils}/bin/sleep 1
      done
    '';
    executable = true;
  };

  unitFile = pkgs.writeTextFile {
    name = "example.service";
    text = ''
      [Unit]
      Description=Example systemd service unit file

      [Service]
      ExecStart=${exampleScript}

      [Install]
      WantedBy=multi-user.target
    '';
  };
in
{
  name = "systemd-misc";

  nodes.machine = { pkgs, lib, ... }: {
    boot.extraSystemdUnitPaths = [ "/etc/systemd-rw/system" ];

    users.users.limited = {
      isNormalUser = true;
      uid = 1000;
    };

    systemd.units."user-1000.slice.d/limits.conf" = {
      text = ''
        [Slice]
        TasksAccounting=yes
        TasksMax=100
      '';
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("mkdir -p /etc/systemd-rw/system")
    machine.succeed(
        "cp ${unitFile} /etc/systemd-rw/system/example.service"
    )
    machine.succeed("systemctl start example.service")
    machine.succeed("systemctl status example.service | grep 'Active: active'")

    machine.succeed("systemctl show --property TasksMax --value user-1000.slice | grep 100")
  '';
})
