# Test ensures buildbot master comes up correctly and workers can connect

import ./make-test-python.nix ({ pkgs, ... }: {
  name = "buildbot";

  nodes = {
    bbmaster = { pkgs, ... }: {
      services.buildbot-master = {
        enable = true;

        # NOTE: use fake repo due to no internet in hydra ci
        factorySteps = [
          "steps.Git(repourl='git://gitrepo/fakerepo.git', mode='incremental')"
          "steps.ShellCommand(command=['bash', 'fakerepo.sh'])"
        ];
        changeSource = [
          "changes.GitPoller('git://gitrepo/fakerepo.git', workdir='gitpoller-workdir', branch='master', pollinterval=300)"
        ];
      };
      networking.firewall.allowedTCPPorts = [ 8010 8011 9989 ];
      environment.systemPackages = with pkgs; [ git buildbot-full ];
    };

    bbworker = { pkgs, ... }: {
      services.buildbot-worker = {
        enable = true;
        masterUrl = "bbmaster:9989";
      };
      environment.systemPackages = with pkgs; [ git buildbot-worker ];
    };

    gitrepo = { pkgs, ... }: {
      services.openssh.enable = true;
      networking.firewall.allowedTCPPorts = [ 22 9418 ];
      environment.systemPackages = with pkgs; [ git ];
      systemd.services.git-daemon = {
        description   = "Git daemon for the test";
        wantedBy      = [ "multi-user.target" ];
        after         = [ "network.target" "sshd.service" ];

        serviceConfig.Restart = "always";
        path = with pkgs; [ coreutils git openssh ];
        environment = { HOME = "/root"; };
        preStart = ''
          git config --global user.name 'Nobody Fakeuser'
          git config --global user.email 'nobody\@fakerepo.com'
          rm -rvf /srv/repos/fakerepo.git /tmp/fakerepo
          mkdir -pv /srv/repos/fakerepo ~/.ssh
          ssh-keyscan -H gitrepo > ~/.ssh/known_hosts
          cat ~/.ssh/known_hosts

          mkdir -p /src/repos/fakerepo
          cd /srv/repos/fakerepo
          rm -rf *
          git init
          echo -e '#!/bin/sh\necho fakerepo' > fakerepo.sh
          cat fakerepo.sh
          touch .git/git-daemon-export-ok
          git add fakerepo.sh .git/git-daemon-export-ok
          git commit -m fakerepo
        '';
        script = ''
          git daemon --verbose --export-all --base-path=/srv/repos --reuseaddr
        '';
      };
    };
  };

  testScript = ''
    gitrepo.wait_for_unit("git-daemon.service")
    gitrepo.wait_for_unit("multi-user.target")

    with subtest("Repo is accessible via git daemon"):
        bbmaster.wait_for_unit("network-online.target")
        bbmaster.succeed("rm -rfv /tmp/fakerepo")
        bbmaster.succeed("git clone git://gitrepo/fakerepo /tmp/fakerepo")

    with subtest("Master service and worker successfully connect"):
        bbmaster.wait_for_unit("buildbot-master.service")
        bbmaster.wait_until_succeeds("curl --fail -s --head http://bbmaster:8010")
        bbworker.wait_for_unit("network-online.target")
        bbworker.succeed("nc -z bbmaster 8010")
        bbworker.succeed("nc -z bbmaster 9989")
        bbworker.wait_for_unit("buildbot-worker.service")

    with subtest("Stop buildbot worker"):
        bbmaster.succeed("systemctl -l --no-pager status buildbot-master")
        bbmaster.succeed("systemctl stop buildbot-master")
        bbworker.fail("nc -z bbmaster 8010")
        bbworker.fail("nc -z bbmaster 9989")
        bbworker.succeed("systemctl -l --no-pager status buildbot-worker")
        bbworker.succeed("systemctl stop buildbot-worker")

    with subtest("Buildbot daemon mode works"):
        bbmaster.succeed(
            "buildbot create-master /tmp",
            "mv -fv /tmp/master.cfg.sample /tmp/master.cfg",
            "sed -i 's/8010/8011/' /tmp/master.cfg",
            "buildbot start /tmp",
            "nc -z bbmaster 8011",
        )
        bbworker.wait_until_succeeds("curl --fail -s --head http://bbmaster:8011")
        bbmaster.wait_until_succeeds("buildbot stop /tmp")
        bbworker.fail("nc -z bbmaster 8011")
  '';

  meta.maintainers = with pkgs.lib.maintainers; [ ];
})
