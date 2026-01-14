{
  name,
  pkgs,
  testBase,
  system,
  ...
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };
runTest (
  {
    config,
    lib,
    ...
  }:
  rec {
    inherit name;

    meta.maintainers = lib.teams.nextcloud.members;

    imports = [ testBase ];

    nodes = {
      nextcloud =
        { config, pkgs, ... }:
        {
          services.nextcloud = {
            config = {
              dbtype = "sqlite";
              adminuser = null;
              adminpassFile = lib.mkForce null;
            };
          };
        };
    };

    adminuser = "root";
    # This needs to be a "secure" password, since the password_policy app is enabled after installation and will forbid "simple" passwords.
    adminpass = "+CVpTwaOEktxsFc6";

    # Manually create the adminuser to make the default set of tests pass.
    # If adminuser was already created during the installation this command would not succeed.
    # This user name must always match the default value in services.nextcloud.config.adminuser!
    test-helpers.init = ''
      nextcloud.succeed("OC_PASS=${adminpass} nextcloud-occ user:add ${adminuser} --password-from-env")
    '';
  }
)
