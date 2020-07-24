# This test runs rabbitmq and checks if rabbitmq is up and running.

import ./make-test-python.nix ({ pkgs, ... }: {
  name = "rabbitmq";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco offline ];
  };

  machine = {
    services.rabbitmq.enable = true;
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("rabbitmq.service")
    machine.wait_until_succeeds(
        'su -s ${pkgs.runtimeShell} rabbitmq -c "rabbitmqctl status"'
    )
  '';
})
