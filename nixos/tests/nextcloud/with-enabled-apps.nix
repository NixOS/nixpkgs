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
      nextcloud =
        { config, pkgs, ... }:
        {
          services.nextcloud = {
            enable = true;
            config.dbtype = "sqlite";
            extraApps = with config.services.nextcloud.package.packages.apps; {
              inherit calendar contacts;
            };
            extraAppsEnable = true;

            # Test the enabledApps functionality
            # only enable extraApps, mandatory and specified ones
            # This should disable e.g. activity, circles, ...
            enabledApps = [
              "federation"
              "user_ldap"
            ];
          };
        };
    };

    test-helpers.extraTests = ''
      with subtest("Test enabledApps functionality"):
          # Get list of enabled apps
          enabled_apps_output = nextcloud.succeed("nextcloud-occ app:list --output=json")
          import json
          app_status = json.loads(enabled_apps_output)
          enabled_apps = list(app_status.get("enabled", {}).keys())
          disabled_apps = list(app_status.get("disabled", {}).keys())

          print(f"Enabled apps: {enabled_apps}")
          print(f"Disabled apps: {disabled_apps}")

          # Check that contacts and calendar are enabled (from enabledApps list)
          assert "contacts" in enabled_apps, "contacts app should be enabled, but enabled apps are: {}".format(enabled_apps)
          assert "calendar" in enabled_apps, "calendar app should be enabled, but enabled apps are: {}".format(enabled_apps)

          # Check that activity is disabled (not in enabledApps list, despite being in extraApps)
          assert "activity" in disabled_apps, "activity app should be disabled, but disabled apps are: {}".format(disabled_apps)

          # Verify mandatory app files are still enabled (these should never be disabled)
          assert "files" in enabled_apps, "files app should be enabled, because it is mandatory but enabled apps are: {}".format(enabled_apps)

      with subtest("Test app enabling/disabling persistence across service restarts"):
          # Manually enable contacts app
          nextcloud.succeed("nextcloud-occ app:enable activity")

          # Restart nextcloud-setup service to trigger the enabledApps logic again
          nextcloud.succeed("systemctl restart nextcloud-setup.service")

          # Verify activity is disabled again after restart
          enabled_apps_output = nextcloud.succeed("nextcloud-occ app:list --output=json")
          app_status = json.loads(enabled_apps_output)
          enabled_apps = list(app_status.get("enabled", {}).keys())
          disabled_apps = list(app_status.get("disabled", {}).keys())

          assert "activity" in disabled_apps, "activity should be disabled again after restart, but disabled apps are: {}".format(disabled_apps)
          assert "calendar" in enabled_apps, "calendar should still be enabled after restart"
    '';
  }
)
