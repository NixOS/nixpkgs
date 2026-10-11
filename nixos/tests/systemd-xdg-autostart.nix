{ runTest }:

let
  # Module to provide common configuration for all test configurations
  node-common = { lib, ... }: {
    imports = [
      ./common/user-account.nix
    ];

    # Start a user session without a graphical environment
    users.users.alice.linger = lib.mkForce true;

    # Most tests need `xdg.autostart.enable = true;` so set it by default
    xdg.autostart.enable = lib.mkDefault true;

    # Add a target to run the autostart items
    # From nixos/modules/services/x11/desktop-managers/none.nix
    systemd.user.targets.run-xdg-autostart = {
      description = "Run XDG autostart files";
      requires = [
        "xdg-desktop-autostart.target"
        "graphical-session.target"
      ];
      before = [
        "xdg-desktop-autostart.target"
        "graphical-session.target"
      ];
      bindsTo = [ "graphical-session.target" ];
    };
  };

  # Module to provide the test library for all test configurations
  node-inject-test-lib = { lib, pkgs, ... }: {
    _module.args.testLib =
      let
        makeAutostartItem =
          {
            name,
            exec,
          }:
          pkgs.makeDesktopItem {
            inherit exec;

            name = "${name}-autostart-item";
            desktopName = "XDG Autostart for ${name}";
            terminal = false;
            categories = [ "Utility" ];
            destination = "/etc/xdg/autostart";
          };

        createFooFilePackage = pkgs.writeShellApplication {
          runtimeInputs = [ pkgs.coreutils ];
          name = "create-foo-file";
          text = ''
            touch "/tmp/$(whoami)-foo-file"
          '';

          passthru.autostartItems = {
            relative = makeAutostartItem {
              name = "create-foo-file-relative-autostart-item";
              exec = createFooFilePackage.meta.mainProgram;
            };

            absolute = makeAutostartItem {
              name = "create-foo-file-absolute-autostart-item";
              exec = lib.getExe createFooFilePackage;
            };
          };
        };
      in
      {
        inherit
          makeAutostartItem
          createFooFilePackage
          ;
      };
  };

  common = {
    nodeDefaults = {
      imports = [
        node-common
        node-inject-test-lib
      ];
    };
  };

  makeTestScript =
    script:
    ''
      from test_driver.errors import RequestedAssertionFailed


      def escape_unit_id(unit_id: str) -> str:
        return unit_id.replace("\\", "\\\\\\") if unit_id.startswith('"') and unit_id.endswith('"') else unit_id


      def wait_for_autostart(machine: QemuMachine, user: str, timeout: int = 900):
        """
        Starts the run-xdg-autostart.target and waits for all of the weak
        dependencies of the xdg-desktop-autostart.target to exit.
        """

        with machine.nested(f"waiting for autostart units to finish for user {user}"):
          machine.wait_for_unit("multi-user.target")

          machine.systemctl("start run-xdg-autostart.target", user=user)

          autostart_info = machine.get_unit_info("xdg-desktop-autostart.target", user=user)
          autostart_wants = autostart_info.get("Wants", "").split()

          for unit_id in autostart_wants:
            escaped_unit_id = escape_unit_id(unit_id)

            unit_type = machine.get_unit_property(escaped_unit_id, "Type", user)
            if unit_type != "exec":
              raise RequestedAssertionFailed(f"Autostart unit {unit_id} is not an exec unit")

            def check_exited(_last_try: bool) -> bool:
              state = machine.get_unit_info(escaped_unit_id, user)
              finished = state["ActiveState"] == "inactive" and "ExecMainExitTimestamp" in state

              if finished and state["Result"] != "success":
                raise RequestedAssertionFailed(f"unit {unit_id} failed with exit code {state['ExecMainStatus']}")

              return finished

            with machine.nested(f"waiting for unit {unit_id} to exit for user {user}"):
              retry(check_exited, timeout)


    ''
    + script;

in
{
  # Basic test to check if the autostart service is generated and executed.
  # `Exec` uses an absolute path.
  basic = runTest (
    { lib, ... }:
    {
      name = "systemd-xdg-autostart-basic";
      meta.maintainers = [ lib.maintainers.limwa ];

      imports = [
        common
      ];

      nodes.machine =
        { testLib, ... }:
        {
          environment.systemPackages = [
            testLib.createFooFilePackage.autostartItems.absolute
          ];
        };

      testScript = makeTestScript ''
        start_all()

        machine.wait_for_unit("multi-user.target")
        machine.fail("test -f /tmp/alice-foo-file")

        wait_for_autostart(machine, user="alice")
        machine.succeed("test -f /tmp/alice-foo-file")
      '';
    }
  );

  # Tests that the autostart desktop entry is not executed if
  # `xdg.autostart.enable = false`.
  disabled = runTest (
    { lib, ... }:
    {
      name = "systemd-xdg-autostart-disabled";
      meta.maintainers = [ lib.maintainers.limwa ];

      imports = [
        common
      ];

      nodes.machine =
        { testLib, ... }:
        {
          xdg.autostart.enable = false;

          environment.systemPackages = [
            testLib.createFooFilePackage.autostartItems.absolute
          ];
        };

      testScript = makeTestScript ''
        start_all()

        machine.wait_for_unit("multi-user.target")
        machine.fail("test -f /tmp/alice-foo-file")

        wait_for_autostart(machine, user="alice")
        machine.fail("test -f /tmp/alice-foo-file")
      '';
    }
  );

  # Test to check if the autostart service can execute commands in the
  # system environment. `Exec` uses the name of a command.
  in-system-environment = runTest (
    { lib, ... }:
    {
      name = "systemd-xdg-autostart-in-system-environment";
      meta.maintainers = [ lib.maintainers.limwa ];

      imports = [
        common
      ];

      nodes.machine =
        { testLib, ... }:
        {
          environment.systemPackages = [
            testLib.createFooFilePackage
            testLib.createFooFilePackage.autostartItems.relative
          ];
        };

      testScript = makeTestScript ''
        start_all()

        machine.wait_for_unit("multi-user.target")
        machine.fail("test -f /tmp/alice-foo-file")

        wait_for_autostart(machine, user="alice")
        machine.succeed("test -f /tmp/alice-foo-file")
      '';
    }
  );

  # Test to check if the autostart service can execute commands in the
  # user environment. `Exec` uses the name of a command.
  in-user-environment = runTest (
    { lib, ... }:
    {
      name = "systemd-xdg-autostart-in-user-environment";
      meta.maintainers = [ lib.maintainers.limwa ];

      imports = [
        common
      ];

      nodes.machine =
        { testLib, ... }:
        {
          environment.systemPackages = [
            testLib.createFooFilePackage.autostartItems.relative
          ];

          users.users.alice.packages = [ testLib.createFooFilePackage ];
          users.users.bob.linger = true;
        };

      testScript = makeTestScript ''
        start_all()

        machine.wait_for_unit("multi-user.target")
        machine.fail("test -f /tmp/alice-foo-file")
        machine.fail("test -f /tmp/bob-foo-file")

        wait_for_autostart(machine, user="alice")
        machine.succeed("test -f /tmp/alice-foo-file")
        machine.fail("test -f /tmp/bob-foo-file")

        wait_for_autostart(machine, user="bob")
        machine.fail("test -f /tmp/bob-foo-file")
      '';
    }
  );
}
