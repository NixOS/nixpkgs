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
  name = "systemd-unit-path";

  machine = { pkgs, lib, ... }: {
    boot.extraSystemdUnitPaths = [ "/etc/systemd-rw/system" ];
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("mkdir -p /etc/systemd-rw/system")
    machine.succeed(
        "cp ${unitFile} /etc/systemd-rw/system/example.service"
    )
    machine.succeed("systemctl start example.service")
    machine.succeed("systemctl status example.service | grep 'Active: active'")
  '';
})
