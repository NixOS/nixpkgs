{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with pkgs.lib;

let
  glanceMysqlPassword = "glanceMysqlPassword";
  glanceAdminPassword = "glanceAdminPassword";

  createDb = pkgs.writeText "db-provisionning.sql" ''
    create database keystone;
    GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'keystone';
    GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'keystone';

    create database glance;
    GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '${glanceMysqlPassword}';
    GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '${glanceMysqlPassword}';
  '';

  image =
    (import ../lib/eval-config.nix {
      inherit system;
      modules = [ ../../nixos/modules/virtualisation/nova-image.nix ];
    }).config.system.build.novaImage;

  # The admin keystone account
  adminOpenstackCmd = "OS_TENANT_NAME=admin OS_USERNAME=admin OS_PASSWORD=keystone OS_AUTH_URL=http://localhost:5000/v3 OS_IDENTITY_API_VERSION=3 openstack";

in makeTest {
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lewo ];
  };
  machine =
    { config, pkgs, ... }:
    {
      services.mysql.enable = true;
      services.mysql.package = pkgs.mysql;
      services.mysql.initialScript = createDb;

      virtualisation = {
        openstack.keystone = {
          enable = true;
          database.password = { value = "keystone"; storage = "fromNixStore"; };
          adminToken = { value = "adminToken"; storage = "fromNixStore"; };
          bootstrap.enable = true;
          bootstrap.adminPassword = { value = "keystone"; storage = "fromNixStore"; };
        };

        openstack.glance = {
          enable = true;
          database.password = { value = glanceMysqlPassword; storage = "fromNixStore"; };
          servicePassword = { value = glanceAdminPassword; storage = "fromNixStore"; };

          bootstrap = {
            enable = true;
            keystoneAdminPassword = { value = "keystone"; storage = "fromNixStore"; };
          };
        };

        memorySize = 2096;
        diskSize = 4 * 1024;
        };

      environment.systemPackages = with pkgs.pythonPackages; with pkgs; [
        openstackclient
      ];
    };

  testScript =
    ''
     $machine->waitForUnit("glance-api.service");

     # Since Glance api can take time to start, we retry until success
     $machine->waitUntilSucceeds("${adminOpenstackCmd} image create nixos --file ${image}/nixos.img --disk-format qcow2 --container-format bare --public");
     $machine->succeed("${adminOpenstackCmd} image list") =~ /nixos/ or die;
    '';
}
