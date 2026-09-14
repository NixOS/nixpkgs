{
  config,
  lib,
  pkgs,
  ...
}:

{
  name = "crash";
  meta.maintainers = with lib.maintainers; [ al3xtjames ];

  nodes.machine =
    { pkgs, ... }:
    {
      boot.crashDump.enable = true;

      environment.systemPackages = with pkgs; [
        crash
      ];
    };

  testScript =
    let
      vmlinux = "${config.nodes.machine.boot.kernelPackages.kernel.dev}/vmlinux";
      crashrc = pkgs.writeText "crashrc" ''
        printf "%s\n", init_uts_ns.name.release > release.txt
        exit
      '';
    in
    ''
      machine.start(allow_reboot=True)

      with subtest("Live debugging succeeds"):
        machine.succeed("crash /proc/kcore ${vmlinux} -i ${crashrc}")
        assert machine.succeed("cat release.txt") == machine.succeed("uname -r")
    '';
}
