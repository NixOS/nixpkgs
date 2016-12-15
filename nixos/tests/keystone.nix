{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with pkgs.lib;

let
  keystoneMysqlPassword = "keystoneMysqlPassword";
  keystoneMysqlPasswordFile = "/var/run/keystoneMysqlPassword";
  keystoneAdminPassword = "keystoneAdminPassword";

  createKeystoneDb = pkgs.writeText "create-keystone-db.sql" ''
    create database keystone;
    GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '${keystoneMysqlPassword}';
    GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '${keystoneMysqlPassword}';
  '';
  # The admin keystone account
  adminOpenstackCmd = "OS_TENANT_NAME=admin OS_USERNAME=admin OS_PASSWORD=${keystoneAdminPassword} OS_AUTH_URL=http://localhost:5000/v3 OS_IDENTITY_API_VERSION=3 openstack";
  # The created demo keystone account
  demoOpenstackCmd = "OS_TENANT_NAME=demo OS_USERNAME=demo OS_PASSWORD=demo OS_AUTH_URL=http://localhost:5000/v3 OS_IDENTITY_API_VERSION=3 openstack";

in makeTest {
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lewo ];
  };
  machine =
    { config, pkgs, ... }:
    {
      # This is to simulate nixops deployment process.
      # https://nixos.org/nixops/manual/#opt-deployment.keys
      boot.postBootCommands = "echo ${keystoneMysqlPassword} > ${keystoneMysqlPasswordFile}";

      services.mysql.enable = true;
      services.mysql.initialScript = createKeystoneDb;

      virtualisation = {

        openstack.keystone = {
	  enable = true;
	  # Check if we can get the secret from a file
	  database.password = {
	    value = keystoneMysqlPasswordFile;
	    storage = "fromFile";
	  };
	  adminToken = {
	    value = "adminToken";
	    storage = "fromNixStore";
	  };

	  bootstrap.enable = true;
	  # Check if we can get the secret from the store
	  bootstrap.adminPassword = {
	    value = keystoneAdminPassword;
	    storage = "fromNixStore";
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
     $machine->waitForUnit("keystone-all.service");

     # Verify that admin ccount is working
     $machine->succeed("${adminOpenstackCmd} token issue");

     # Try to create a new user
     $machine->succeed("${adminOpenstackCmd} project create --domain default --description 'Demo Project' demo");
     $machine->succeed("${adminOpenstackCmd} user create --domain default --password demo demo");
     $machine->succeed("${adminOpenstackCmd} role create user");
     $machine->succeed("${adminOpenstackCmd} role add --project demo --user demo user");

     # Verify this new account is working
     $machine->succeed("${demoOpenstackCmd} token issue");
    '';
}
