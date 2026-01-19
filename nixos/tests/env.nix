{ pkgs, ... }:
{
  name = "environment";

  nodes.machine =
    { pkgs, lib, ... }:
    lib.mkMerge [
      {
        boot.kernelPackages = pkgs.linuxPackages;
        environment.etc.plainFile.text = ''
          Hello World
        '';
        environment.etc."folder/with/file".text = ''
          Foo Bar!
        '';

        environment.sessionVariables = {
          TERMINFO_DIRS = "/run/current-system/sw/share/terminfo";
          NIXCON = "awesome";
          SHOULD_NOT_BE_SET = "oops";
        };
      }
      {
        environment.sessionVariables = {
          SHOULD_NOT_BE_SET = lib.mkForce null;
        };
      }
    ];

  testScript = ''
    machine.succeed('[ -L "/etc/plainFile" ]')
    assert "Hello World" in machine.succeed('cat "/etc/plainFile"')
    machine.succeed('[ -d "/etc/folder" ]')
    machine.succeed('[ -d "/etc/folder/with" ]')
    machine.succeed('[ -L "/etc/folder/with/file" ]')
    assert "Hello World" in machine.succeed('cat "/etc/plainFile"')

    assert "/run/current-system/sw/share/terminfo" in machine.succeed(
        "echo ''${TERMINFO_DIRS}"
    )
    assert "awesome" in machine.succeed("echo ''${NIXCON}")
    machine.fail("printenv SHOULD_NOT_BE_SET")
  '';
}
