# This test has been broken but still signaled "green" earlier on.
# I have disabled it for now.
import <nixpkgs/nixos/tests/make-test.nix> ({ pkgs, ...} : {
  name = "sensuserver";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ theuni ];
  };

  nodes = {
    master =
      { pkgs, config, ... }:

      {
        imports = [ ../manage/default.nix
                    ../static/default.nix
                    ../roles/default.nix
                    ../services/default.nix
                    ../packages/default.nix
                    ../platform/default.nix ];

        flyingcircus.roles.mysql.enable = true;

      };
  };

  testScript = ''
    startAll;

    $master->waitForUnit("mysql");

    # $master->sleep(10);
    # This test was screwed and for some reason passed earlier on.
    # This is only to ensure we build the packages, for now.
    # $master->succeed("systemctl status sensu-server.service");
    # $master->succeed("systemctl status sensu-api.service");
    # $master->succeed("systemctl status uchiwa.service");
  '';
})
