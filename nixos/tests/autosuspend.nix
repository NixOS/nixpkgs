{ lib, pkgs, ... }:

{
  name = "autosuspend";
  meta.maintainers = [ lib.maintainers.anthonyroussel ];

  nodes = {
    machine = {
      services.autosuspend = {
        enable = true;

        settings = {
          interval = 5;
          idle_time = 5;
          suspend_cmd = "${pkgs.coreutils}/bin/touch /tmp/suspended";
        };

        # Return exit code 1 to trigger suspend
        checks.ExternalCommand.command = "exit 1";
      };
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("autosuspend.service")
    machine.wait_for_file("/tmp/suspended")
  '';
}
