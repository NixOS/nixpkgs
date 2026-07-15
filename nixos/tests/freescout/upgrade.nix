# This tests checks, wether upgrading between versions works fine
# In the past, there have been releases that would require manual deletion of specific
# cache files, otherwise bricking the installation.
# This test should catch similar instances in the future.
# The oldFreescoutVersion may need a bump from time to time as there may be incompatibilities
# with up-to-date databases on older freescout versions.
{
  pkgs,
  lib,
  ...
}:

let
  freescoutDomain = "freescout.local";

  oldFreescoutVersion = pkgs.freescout.overrideAttrs (oa: rec {
    version = "1.8.220";
    src = pkgs.fetchFromGitHub {
      owner = "freescout-help-desk";
      repo = "freescout";
      tag = version;
      hash = "sha256-bOkazBcd9EKzQdZZA6YMn4+UNYhpDFV9hDMHR5kXke0=";
    };
  });
  newFreescoutVersion = pkgs.freescout;
in
{
  name = "freescout-upgrade";
  meta.maintainers = with lib.maintainers; [
    e1mo
  ];

  nodes.machine =
    { config, lib, ... }:
    {
      networking.extraHosts = ''
        127.0.0.1 ${freescoutDomain}
      '';
      virtualisation.memorySize = 1024;
      environment.systemPackages = with pkgs; [
        curl
        jq
      ];
      services.freescout = {
        package = oldFreescoutVersion;
        enable = true;
        domain = freescoutDomain;
        settings = {
          APP_KEY = "base64:J8ZgK5LZkhVKpmZvjjA700sNL7+Y6aQTus8ZnUNNAaE=";
          APP_FORCE_HTTPS = false;
          APP_URL = "http://${freescoutDomain}:8888";
          APP_DEBUG = true;
        };
        databaseSetup = {
          enable = true;
          kind = "pgsql";
        };
      };
      specialisation.upgrade.configuration.services.freescout.package = lib.mkForce newFreescoutVersion;
    };

  testScript =
    { nodes, ... }:
    let
      oldVersion = nodes.machine.services.freescout.package.version;
      newVersion = nodes.machine.specialisation.upgrade.configuration.services.freescout.package.version;
    in
    ''
      machine.start()
      machine.wait_for_unit("nginx")
      machine.wait_for_unit("postgresql")
      machine.wait_for_unit("freescout-setup")

      with subtest("Create user and log in"):
        # Create uesr
        machine.succeed("/var/lib/freescout/artisan freescout:create-user --role=admin --firstName=Xenia --lastName=TheFox --email xenia@${freescoutDomain} --no-interaction --password=foo | grep 'User created with id'")
        # Obtain CSRF token
        token=machine.succeed("curl -fsSL --cookie-jar cjar 'http://${freescoutDomain}/login' | grep -Po '(?<= name=\"_token\" value=\")(\w+)(?=\")'").strip()
        # Actually log in
        data=f"email=xenia%40${freescoutDomain}&password=foo&_token={token}&remember=on"
        machine.succeed(f"curl -sSfX POST --cookie-jar cjar --cookie cjar --data-raw '{data}' 'http://${freescoutDomain}/login' | grep 'Redirecting to'")

      with subtest("Check old API version"):
        machine.succeed("curl -fsSL --cookie-jar cjar --cookie cjar 'http://${freescoutDomain}/system/status' | grep ${oldVersion}")

      machine.execute("${nodes.machine.system.build.toplevel}/specialisation/upgrade/bin/switch-to-configuration test >&2")

      machine.wait_for_unit("nginx")
      machine.wait_for_unit("freescout-setup")

      with subtest("Check new API version"):
        machine.succeed("curl -fsSL --cookie-jar cjar --cookie cjar 'http://${freescoutDomain}/system/status' | grep ${newVersion}")
    '';
}
