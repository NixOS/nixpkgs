{ lib, pkgs, ... }:

{
  name = "jolt";
  meta.maintainers = with lib.maintainers; [ crimeminister ];

  nodes.machine =
    { pkgs, ... }:
    {
      programs.jolt = {
        enable = true;
        chezPackage = pkgs.chez;
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("jolt --version | grep -q '${pkgs.jolt.version}'")
    machine.succeed("test -x \"$JOLT_CHEZ\"")
  '';
}
