import ./make-test-python.nix (
  { pkgs, lib, ... }:

  {
    name = "alertmanager-executor";
    meta.maintainers = with lib.maintainers; [ mmilata ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.alertmanager-executor = {
          enable = true;
          settings = {
            listen_address = "localhost:20202";
            extraFlags = [ "-v" ];
            commands = [ { cmd = "${pkgs.hello}/bin/hello"; } ];
          };
        };
      };

    testScript = ''
      start_all()
      machine.wait_for_unit("alertmanager-executor.service")
      machine.wait_for_open_port(20202)
    '';
  }
)
