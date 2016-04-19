# This test has been broken but still signaled "green" earlier on.
# I have disabled it for now.
import <nixpkgs/nixos/tests/make-test.nix> ({ pkgs, ...} : {
  name = "percona";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ theuni ];
  };

  nodes = {
    master =
      { pkgs, config, ... }:

      {
        imports = [ ../static/default.nix
                    ../roles/default.nix
                    ../services/default.nix
                    ../packages/default.nix
                    ../platform/default.nix ];

        flyingcircus.ssl.generate_dhparams = false;
        flyingcircus.roles.mysql.enable = true;

        # Tune those arguments as we'd like to run this on Hydra
        # in a rather small VM.
        flyingcircus.roles.mysql.extraConfig = ''
            [mysqld]
            innodb-buffer-pool-size         = 10M
            innodb_log_file_size            = 10M
        '';

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
