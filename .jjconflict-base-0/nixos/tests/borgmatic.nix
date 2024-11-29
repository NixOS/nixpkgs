import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "borgmatic";
  nodes.machine = { ... }: {
    services.borgmatic = {
      enable = true;
      settings = {
        source_directories = [ "/home" ];
        repositories = [
          {
            label = "local";
            path = "/var/backup";
          }
        ];
        keep_daily = 7;
      };
    };
  };

  testScript = ''
    machine.succeed("borgmatic rcreate -e none")
    machine.succeed("borgmatic")
  '';
})
