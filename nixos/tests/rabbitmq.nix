{ pkgs, ... }:

# This test runs rabbitmq and checks if rabbitmq is up and running

{
  nodes = {
    one = { config, pkgs, ... }: {
      services.rabbitmq.enable = true;
    };
  };

  testScript = ''
    startAll;
  
    $one->waitForUnit("rabbitmq.service");
    $one->waitUntilSucceeds("su -s ${pkgs.stdenv.shell} rabbitmq -c \"rabbitmqctl status\"");
  '';
}
