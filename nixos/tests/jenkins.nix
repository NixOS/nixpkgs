{ pkgs, ... }:
{
  nodes = {
    master = { pkgs, config, ... }: {
        services.jenkins.enable = true;
      };
  };

  testScript = ''
    startAll;

    $master->waitForUnit("jenkins");
  '';
}
