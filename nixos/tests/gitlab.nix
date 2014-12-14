# This test runs gitlab and checks if it works

import ./make-test.nix {
  name = "gitlab";

  nodes = {
    gitlab = { config, pkgs, ... }: {
      virtualisation.memorySize = 768;
      services.gitlab.enable = true;
      services.gitlab.databasePassword = "gitlab";
    };
  };

  testScript = ''
    $gitlab->start();
    $gitlab->waitForUnit("gitlab.service");
    $gitlab->waitForUnit("gitlab-sidekiq.service");
    $gitlab->waitUntilSucceeds("curl http://localhost:8080/users/sign_in");
  '';
}
