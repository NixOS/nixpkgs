# Test ensures buildbot master comes up correctly and workers can connect

import ./make-test.nix ({ pkgs, ... } : {
  name = "buildbot";

  nodes = {
    bbmaster = { config, pkgs, ... }: {
      services.buildbot-master = {
        enable = true;
        package = pkgs.buildbot-full;

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

    bbworker = { config, pkgs, ... }: {
      services.buildbot-worker = {
        enable = true;
        masterUrl = "bbmaster:9989";
      };
      environment.systemPackages = with pkgs; [ git buildbot-worker ];
    };

    gitrepo = { config, pkgs, ... }: {
      services.openssh.enable = true;
      networking.firewall.allowedTCPPorts = [ 22 9418 ];
      environment.systemPackages = with pkgs; [ git ];
    };
  };

  testScript = ''
    #Start up and populate fake repo
    $gitrepo->waitForUnit("multi-user.target");
    print($gitrepo->execute(" \
      git config --global user.name 'Nobody Fakeuser' && \
      git config --global user.email 'nobody\@fakerepo.com' && \
      rm -rvf /srv/repos/fakerepo.git /tmp/fakerepo && \
      mkdir -pv /srv/repos/fakerepo ~/.ssh && \
      ssh-keyscan -H gitrepo > ~/.ssh/known_hosts && \
      cat ~/.ssh/known_hosts && \
      cd /srv/repos/fakerepo && \
      git init && \
      echo -e '#!/bin/sh\necho fakerepo' > fakerepo.sh && \
      cat fakerepo.sh && \
      touch .git/git-daemon-export-ok && \
      git add fakerepo.sh .git/git-daemon-export-ok && \
      git commit -m fakerepo && \
      git daemon --verbose --export-all --base-path=/srv/repos --reuseaddr & \
    "));

    # Test gitrepo
    $bbmaster->waitForUnit("network-online.target");
    #$bbmaster->execute("nc -z gitrepo 9418");
    print($bbmaster->execute(" \
      rm -rfv /tmp/fakerepo && \
      git clone git://gitrepo/fakerepo /tmp/fakerepo && \
      pwd && \
      ls -la && \
      ls -la /tmp/fakerepo \
    "));

    # Test start master and connect worker
    $bbmaster->waitForUnit("buildbot-master.service");
    $bbmaster->waitUntilSucceeds("curl -s --head http://bbmaster:8010") =~ /200 OK/;
    $bbworker->waitForUnit("network-online.target");
    $bbworker->execute("nc -z bbmaster 8010");
    $bbworker->execute("nc -z bbmaster 9989");
    $bbworker->waitForUnit("buildbot-worker.service");
    print($bbworker->execute("ls -la /home/bbworker/worker"));


    # Test stop buildbot master and worker
    print($bbmaster->execute(" \
      systemctl -l --no-pager status buildbot-master && \
      systemctl stop buildbot-master \
    "));
    $bbworker->fail("nc -z bbmaster 8010");
    $bbworker->fail("nc -z bbmaster 9989");
    print($bbworker->execute(" \
      systemctl -l --no-pager status buildbot-worker && \
      systemctl stop buildbot-worker && \
      ls -la /home/bbworker/worker \
    "));


    # Test buildbot daemon mode
    # NOTE: daemon mode tests disabled due to broken PYTHONPATH child inheritence
    #
    #$bbmaster->execute("buildbot create-master /tmp");
    #$bbmaster->execute("mv -fv /tmp/master.cfg.sample /tmp/master.cfg");
    #$bbmaster->execute("sed -i 's/8010/8011/' /tmp/master.cfg");
    #$bbmaster->execute("buildbot start /tmp");
    #$bbworker->execute("nc -z bbmaster 8011");
    #$bbworker->waitUntilSucceeds("curl -s --head http://bbmaster:8011") =~ /200 OK/;
    #$bbmaster->execute("buildbot stop /tmp");
    #$bbworker->fail("nc -z bbmaster 8011");

  '';

  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ nand0p ];

})
