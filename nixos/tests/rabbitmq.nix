# This test runs rabbitmq and checks if rabbitmq is up and running.

import ./make-test-python.nix ({ pkgs, ... }: {
  name = "rabbitmq";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ eelco offline ];
  };

  nodes.machine = {
    services.rabbitmq = {
      enable = true;
      managementPlugin.enable = true;
    };
    # Ensure there is sufficient extra disk space for rabbitmq to be happy
    virtualisation.diskSize = 1024;
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("rabbitmq.service")
    machine.wait_until_succeeds(
        'su -s ${pkgs.runtimeShell} rabbitmq -c "rabbitmqctl status"'
    )
    machine.wait_for_open_port(15672)
  '';
})
