import <nixpkgs/nixos/tests/make-test.nix> ({ pkgs, ...} : {
  name = "sensuserver";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ theuni ];
  };

  nodes = {
    master =
      { pkgs, config, ... }:

      {
        imports = [ ../services/default.nix
                    ../packages/default.nix
                    ../platform/default.nix ];

        flyingcircus.services.sensu-server.enable = true;
        flyingcircus.services.sensu-api.enable = true;
        flyingcircus.services.uchiwa.enable = true;
      };
  };

  testScript = ''
    startAll;

    $master->waitForUnit("sensu-server");
    $master->sleep(10); # Hopefully this is long enough!!
    $master->succeed("systemctl status sensu-server.service");
    $master->succeed("systemctl status sensu-api.service");
    $master->succeed("systemctl status uchiwa.service");
  '';
})
