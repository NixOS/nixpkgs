import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "environment";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ nequissimus ];
    };

    nodes.machine =
      { pkgs, ... }:
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
        };
      };

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
    '';
  }
)
