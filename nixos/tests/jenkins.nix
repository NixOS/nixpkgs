# verifies:
#   1. jenkins service starts on master node
#   2. jenkins user can be extended on both master and slave
#   3. jenkins service not started on slave node

import ./make-test.nix ({ pkgs, ...} : {
  name = "jenkins";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ bjornfor coconnor domenkozar eelco ];
  };

  nodes = {

    master =
      { ... }:
      { services.jenkins.enable = true;

        # should have no effect
        services.jenkinsSlave.enable = true;

        users.users.jenkins.extraGroups = [ "users" ];

        systemd.services.jenkins.serviceConfig.TimeoutStartSec = "6min";
      };

    slave =
      { ... }:
      { services.jenkinsSlave.enable = true;

        users.users.jenkins.extraGroups = [ "users" ];
      };

  };

  testScript = ''
    startAll;

    $master->waitForUnit("jenkins");

    $master->mustSucceed("curl http://localhost:8080 | grep 'Authentication required'");

    print $master->execute("sudo -u jenkins groups");
    $master->mustSucceed("sudo -u jenkins groups | grep jenkins | grep users");

    print $slave->execute("sudo -u jenkins groups");
    $slave->mustSucceed("sudo -u jenkins groups | grep jenkins | grep users");

    $slave->mustFail("systemctl is-enabled jenkins.service");
  '';
})
