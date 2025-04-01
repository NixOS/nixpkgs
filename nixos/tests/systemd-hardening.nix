import ./make-test-python.nix (
  { pkgs, lib, ... }:

  {
    name = "systemd-misc";

    nodes.machine =
      { pkgs, lib, ... }:
      {

        systemd.services.unprivileged_service = {
          lockdownByDefault = "rev1";
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = lib.getExe pkgs.hello;
            Type = "oneshot";
            RemainAfterExit = "yes";
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")

      with subtest("unprivileged service executed successfully"):
          machine.succeed("systemctl status unprivileged_service")

      with subtest("unprivileged service analysis comes back with low exposure"):
          machine.succeed("${lib.getExe' pkgs.diffutils "diff"} -u <((systemd-analyze security unprivileged_service.service --json pretty --no-pager | ${lib.getExe pkgs.jq} '[.[] | select(.exposure != null and .set == false ) | (.exposure | tonumber) ] | add - 1 < 3')) <(echo true)")
    '';
  }
)
