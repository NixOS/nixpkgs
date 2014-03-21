# verifies:
#   1. jenkins service starts on master node
#   2. jenkins user can be extended on both master and slave
#   3. jenkins service not started on slave node
{ pkgs, ... }:
{
  nodes = {
    master = { pkgs, config, ... }: {
        services.jenkins.enable = true;

        # should have no effect
        services.jenkinsSlave.enable = true;

        users.extraUsers.jenkins.extraGroups = [ "users" ];
      };
    slave = { pkgs, config, ... }: {
        services.jenkinsSlave.enable = true;

        users.extraUsers.jenkins.extraGroups = [ "users" ];
      };
  };

  testScript = ''
    startAll;

    $master->waitForUnit("jenkins");
    print $master->execute("sudo -u jenkins groups");
    $master->mustSucceed("sudo -u jenkins groups | grep jenkins | grep users");

    print $slave->execute("sudo -u jenkins groups");
    $slave->mustSucceed("sudo -u jenkins groups | grep jenkins | grep users");

    $slave->mustFail("systemctl status jenkins.service");
  '';
}
