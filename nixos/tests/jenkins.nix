# verifies:
#   1. jenkins service starts on master node
#   2. jenkins user can be extended on both master and slave
#   3. jenkins service not started on slave node

import ./make-test-python.nix ({ pkgs, ...} : {
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
    start_all()

    master.wait_for_unit("jenkins")

    assert "Authentication required" in master.succeed("curl http://localhost:8080")

    for host in master, slave:
        groups = host.succeed("sudo -u jenkins groups")
        assert "jenkins" in groups
        assert "users" in groups

    slave.fail("systemctl is-enabled jenkins.service")
  '';
})
