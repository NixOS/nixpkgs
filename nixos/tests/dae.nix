import ./make-test-python.nix ({ lib, pkgs, ... }: {

  name = "dae";

  meta = {
    maintainers = with lib.maintainers; [ oluceps ];
  };

  nodes.machine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.curl ];
    services.nginx = {
      enable = true;
      statusPage = true;
    };
    services.dae = {
      enable = true;
      config = ''
        global { disable_waiting_network: true }
        routing{}
      '';
    };
  };

  testScript = ''
    machine.wait_for_unit("nginx.service")
    machine.wait_for_unit("dae.service")

    machine.wait_for_open_port(80)

    machine.succeed("curl --fail --max-time 10 http://localhost")
  '';

})
