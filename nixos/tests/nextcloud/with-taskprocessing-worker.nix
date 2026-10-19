{
  name,
  pkgs,
  testBase,
  system,
  ...
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };
runTest (
  { config, lib, ... }:
  {
    inherit name;
    meta.maintainers = lib.teams.nextcloud.members;

    imports = [ testBase ];

    nodes = {
      nextcloud = {
        services.nextcloud = {
          config.dbtype = "pgsql";
          enableTaskprocessingWorker = true;
        };
      };
    };

    test-helpers.extraTests = ''
      with subtest("TaskProcessing worker is running"):
          nextcloud.wait_for_unit("nextcloud-taskprocessing-worker.service")
          nextcloud.succeed("pgrep -u nextcloud -f 'taskprocessing:worker'")
    '';
  }
)
