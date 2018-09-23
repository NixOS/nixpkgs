import ./make-test.nix ({ pkgs, ...} : {
  name = "nextcloud";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ globin ];
  };

  nodes = {
    nextcloud = { config, pkgs, ... }: {
      #virtualisation.memorySize = 768;
      services.nextcloud = {
        enable = true;
        nginx.enable = true;
        hostName = "nextcloud";
        autoconfig.adminpass = "notproduction";
      };

      networking.firewall.enable = false;
    };
  };

  testScript = ''
    $nextcloud->start();
    $nextcloud->waitForUnit("nginx");
    $nextcloud->waitForUnit("phpfpm-nextcloud");
    $nextcloud->succeed("curl -sSf http://nextcloud/login");
  '';
})
