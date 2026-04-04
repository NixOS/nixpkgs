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
        print (char *)init_uts_ns.name.release > release.txt
        exit
      '';
    in
    ''
      machine.start(allow_reboot=True)

      with subtest("Live debugging succeeds"):
        machine.succeed("crash /proc/kcore ${vmlinux} -i ${crashrc}")
        crash_release = machine.succeed("cat release.txt").splitlines()[1].split()[-1].replace("\"", "")
        uname_release = machine.succeed("uname -r").rstrip()
        assert crash_release == uname_release
    '';
}
