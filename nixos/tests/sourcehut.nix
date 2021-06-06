import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "sourcehut";

  meta.maintainers = [ pkgs.lib.maintainers.tomberek ];

  machine = { config, pkgs, ... }: {
    virtualisation.memorySize = 2048;
    networking.firewall.allowedTCPPorts = [ 80 ];

    services.sourcehut = {
      enable = true;
      services = [ "meta" ];
      originBase = "sourcehut";
      settings."sr.ht".service-key =   "8888888888888888888888888888888888888888888888888888888888888888";
      settings."sr.ht".network-key = "0000000000000000000000000000000000000000000=";
      settings.webhooks.private-key = "0000000000000000000000000000000000000000000=";
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("metasrht.service")
    machine.wait_for_open_port(5000)
    machine.succeed("curl -sL http://localhost:5000 | grep meta.sourcehut")
  '';
})
