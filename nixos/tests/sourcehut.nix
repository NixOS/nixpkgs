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
      redis.enable = true;
      postgresql.enable = true;
      meta.enable = true;
      settings."sr.ht" = {
        global-domain = "sourcehut";
        service-key = pkgs.writeText "service-key" "8b327279b77e32a3620e2fc9aabce491cc46e7d821fd6713b2a2e650ce114d01";
        network-key = pkgs.writeText "network-key" "cEEmc30BRBGkgQZcHFksiG7hjc6_dK1XR2Oo5Jb9_nQ=";
      };
      settings.webhooks.private-key = pkgs.writeText "webhook-key" "Ra3IjxgFiwG9jxgp4WALQIZw/BMYt30xWiOsqD0J7EA=";
    };
    services.postgresql = {
      enable = true;
      enableTCPIP = false;
      settings.unix_socket_permissions = "0770";
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
