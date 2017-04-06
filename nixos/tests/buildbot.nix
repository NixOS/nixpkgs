# Test ensures buildbot master comes up correctly and workers can connect

import ./make-test.nix ({ pkgs, ... } : {
  name = "buildbot";

  nodes = {
    bbmaster = { config, pkgs, nodes, ... }: {
      services.buildbot-master = {
        enable = true;
        factorySteps = [
          "steps.Git(repourl='git://github.com/buildbot/pyflakes.git', mode='incremental')"
          "steps.ShellCommand(command=['trial', 'pyflakes'])"
        ];
        changeSource = [
          "changes.GitPoller('git://github.com/buildbot/pyflakes.git', workdir='gitpoller-workdir', branch='master', pollinterval=300)"
        ];
      };
      networking.firewall.allowedTCPPorts = [ 8010 9989 ];
    };

    bbworker = { config, pkgs, ... }: {
      services.buildbot-worker = {
        enable = true;
        masterUrl = "bbmaster:9989";
      };
    };
  };

  testScript = ''

    $bbmaster->waitForUnit("network.target");
    $bbworker->waitForUnit("network.target");

    # Additional tests to be added
    #$bbmaster->waitForUnit("buildbot-master.service");
    #$bbmaster->waitUntilSucceeds("curl -s --head http://bbmaster:8010") =~ /200 OK/ or die;
    #$bbworker->waitForUnit("buildbot-worker.service");
    #$bbworker->waitUntilSucceeds("tail -10 /home/bbworker/worker/twistd.log") =~ /success/ or die;

  '';

  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nand0p ];
  };

})
