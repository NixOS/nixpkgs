# This test runs gitlab and checks if it works

import ./make-test.nix ({ pkgs, ...} : {
  name = "gitlab";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ domenkozar offline ];
  };

  nodes = {
    gitlab = { config, pkgs, ... }: {
      virtualisation.memorySize = 768;
      services.gitlab.enable = true;
      services.gitlab.databasePassword = "gitlab";
      services.gitlab.secrets = {
        secret = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
        db = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
        jws = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
        otp = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
      };
      systemd.services.gitlab.serviceConfig.TimeoutStartSec = "infinite";
    };
  };

  testScript = ''
    $gitlab->start();
    $gitlab->waitForUnit("gitlab.service");
    $gitlab->waitForUnit("gitlab-sidekiq.service");
    $gitlab->waitUntilSucceeds("curl http://localhost:8080/users/sign_in");
  '';
})
