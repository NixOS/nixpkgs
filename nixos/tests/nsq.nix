# This test runs the NSQ daemons and checks if they are up and running.

import ./make-test.nix ({ pkgs, ... }: {
  name = "nsq";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ pjones ];
  };

  nodes = {
    one = { ... }: {
      services.nsq = {
        nsqd.enable = true;
        nsqlookupd.enable = true;
        nsqadmin.enable = true;
      };
    };
  };

  testScript = ''
    startAll;

    $one->waitForUnit("nsqd.service");
    $one->succeed("curl --fail http://localhost:4151/ping");

    $one->waitForUnit("nsqlookupd.service");
    $one->succeed("curl --fail http://localhost:4161/ping");

    $one->waitForUnit("nsqadmin.service");
    $one->succeed("curl --fail http://localhost:4171/ping");
  '';
})
