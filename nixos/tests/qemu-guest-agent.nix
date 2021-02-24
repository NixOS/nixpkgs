import ./make-test-python.nix ({ pkgs, ... }:
let
  # qemu-ga-execstart = "${pkgs.qemu.ga}/bin/qemu-ga -f /var/run/qemu-ga.pid -m isa-serial";
  qemu-ga-execstart = "${pkgs.qemu.ga}/bin/qemu-ga -l /var/run/qga.log -f /var/run/qemu-ga.pid";

  print_unit_file = pkgs: unit: pkgs.writeScriptBin "print-${unit}-file" ''
    #!${pkgs.bash}/bin/bash
    echo 'UNIT ${unit}: ' 1>&2
    export UNITFILE=$(systemctl show ${unit}.service | ${pkgs.gnugrep}/bin/grep FragmentPath= | ${pkgs.coreutils}/bin/cut -d= -f2)
    echo Unit file is : \`$UNITFILE\` 1>&2
    cat $UNITFILE 1>&2
    echo 'UNIT FILE END' 1>&2
  '';
in
{
  name = "qemu-guest-agent";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ shamilton ];
  };

  nodes = {
    machine = { pkgs, lib, ... }: {
      imports = [ ./common/x11.nix ];
      systemd.services.qemu-guest-agent.serviceConfig.ExecStart = lib.mkForce qemu-ga-execstart;
      services.qemuGuest.enable = true;
      environment.systemPackages = with pkgs; [ qemu (print_unit_file pkgs "qemu-guest-agent") ];
    };
  };

  testScript = { nodes, ... }: ''
    start_all()
    machine.wait_for_x()
    machine.succeed(
        "export DISPLAY=:0",
        "qemu-system-x86_64 &",
    )
    machine.succeed("print-qemu-guest-agent-file")
    machine.succeed("systemctl start qemu-guest-agent.service 1>&2")
    machine.succeed("systemctl start qemu-guest-agent.socket 1>&2 ")
    machine.wait_for_unit("qemu-guest-agent.service")
    machine.succeed("journalctl -xe -u qemu-guest-agent.service 1>&2")
    machine.succeed("systemctl status qemu-guest-agent.service 1>&2")
  '';
})
