let
  user = "someuser";
  password = "some_password";
  port = builtins.toString 5232;

  common = { pkgs, ... }: {
    services.radicale = {
      enable = true;
      config = ''
        [auth]
        type = htpasswd
        htpasswd_filename = /etc/radicale/htpasswd
        htpasswd_encryption = bcrypt

        [storage]
        filesystem_folder = /tmp/collections

        [logging]
        debug = True
      '';
    };
    # WARNING: DON'T DO THIS IN PRODUCTION!
    # This puts secrets (albeit hashed) directly into the Nix store for ease of testing.
    environment.etc."radicale/htpasswd".source = pkgs.runCommand "htpasswd" {} ''
      ${pkgs.apacheHttpd}/bin/htpasswd -bcB "$out" ${user} ${password}
    '';
  };

in

  import ./make-test.nix ({ pkgs, lib, ... }@args: {
    name = "radicale";
    meta.maintainers = with lib.maintainers; [ aneeshusa infinisil ];

    nodes = rec {
      radicale = radicale1; # Make the test script read more nicely
      radicale1 = lib.recursiveUpdate (common args) {
        nixpkgs.overlays = [
          (self: super: {
            radicale1 = super.radicale1.overrideAttrs (oldAttrs: {
              propagatedBuildInputs = with self.pythonPackages;
                (oldAttrs.propagatedBuildInputs or []) ++ [ passlib ];
            });
          })
        ];
        system.stateVersion = "17.03";
      };
      radicale1_export = lib.recursiveUpdate radicale1 {
        services.radicale.extraArgs = [
          "--export-storage" "/tmp/collections-new"
        ];
      };
      radicale2_verify = lib.recursiveUpdate radicale2 {
        services.radicale.extraArgs = [ "--verify-storage" ];
      };
      radicale2 = lib.recursiveUpdate (common args) {
        system.stateVersion = "17.09";
      };
    };

    # This tests whether the web interface is accessible to an authenticated user
    testScript = { nodes }: let
      switchToConfig = nodeName: let
        newSystem = nodes.${nodeName}.config.system.build.toplevel;
      in "${newSystem}/bin/switch-to-configuration test";
    in ''
      # Check Radicale 1 functionality
      $radicale->succeed('${switchToConfig "radicale1"} >&2');
      $radicale->waitForUnit('radicale.service');
      $radicale->waitForOpenPort(${port});
      $radicale->succeed('curl --fail http://${user}:${password}@localhost:${port}/someuser/calendar.ics/');

      # Export data in Radicale 2 format
      $radicale->succeed('systemctl stop radicale');
      $radicale->succeed('ls -al /tmp/collections');
      $radicale->fail('ls -al /tmp/collections-new');
      # Radicale exits immediately after exporting storage
      $radicale->succeed('${switchToConfig "radicale1_export"} >&2');
      $radicale->waitUntilFails('systemctl status radicale');
      $radicale->succeed('ls -al /tmp/collections');
      $radicale->succeed('ls -al /tmp/collections-new');

      # Verify data in Radicale 2 format
      $radicale->succeed('rm -r /tmp/collections/${user}');
      $radicale->succeed('mv /tmp/collections-new/collection-root /tmp/collections');
      $radicale->succeed('${switchToConfig "radicale2_verify"} >&2');
      $radicale->waitUntilFails('systemctl status radicale');
      my ($retcode, $logs) = $radicale->execute('journalctl -u radicale -n 5');
      if ($retcode != 0 || index($logs, 'Verifying storage') == -1) {
        die "Radicale 2 didn't verify storage"
      }
      if (index($logs, 'failed') != -1 || index($logs, 'exception') != -1) {
        die "storage verification failed"
      }

      # Check Radicale 2 functionality
      $radicale->succeed('${switchToConfig "radicale2"} >&2');
      $radicale->waitForUnit('radicale.service');
      $radicale->waitForOpenPort(${port});
      my ($retcode, $output) = $radicale->execute('curl --fail http://${user}:${password}@localhost:${port}/someuser/calendar.ics/');
      if ($retcode != 0 || index($output, 'VCALENDAR') == -1) {
        die "Could not read calendar from Radicale 2"
      }
      $radicale->succeed('curl --fail http://${user}:${password}@localhost:${port}/.web/');
    '';
})
