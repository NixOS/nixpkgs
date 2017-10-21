import ./make-test.nix ({ pkgs, ...} : {
  name = "hydra-init-localdb";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ pstn ];
  };

  machine =
    { config, pkgs, ... }:

    {
      services.hydra = {
        enable = true;

        #Hydra needs those settings to start up, so we add something not harmfull.
        hydraURL = "example.com";
        notificationSender = "example@example.com";
      };
    };

  testScript =
    ''
      # let the system boot up
      $machine->waitForUnit("multi-user.target");
      # test whether the database is running
      $machine->succeed("systemctl status postgresql.service");
      # test whether the actual hydra daemons are running
      $machine->succeed("systemctl status hydra-queue-runner.service");
      $machine->succeed("systemctl status hydra-init.service");
      $machine->succeed("systemctl status hydra-evaluator.service");
      $machine->succeed("systemctl status hydra-send-stats.service");
     '';
})
