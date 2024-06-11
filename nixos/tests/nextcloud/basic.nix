{ name, pkgs, testBase, system,... }:

with import ../../lib/testing-python.nix { inherit system pkgs; };
runTest ({ config, ... }: {
  inherit name;
  meta = with pkgs.lib.maintainers; {
    maintainers = [ globin eqyiel ma27 ];
  };

  imports = [ testBase ];

  nodes = {
    # The only thing the client needs to do is download a file.
    client = { ... }: {
      services.davfs2.enable = true;
      systemd.tmpfiles.settings.nextcloud = {
        "/tmp/davfs2-secrets"."f+" = {
          mode = "0600";
          argument = "http://nextcloud/remote.php/dav/files/${config.adminuser} ${config.adminuser} ${config.adminpass}";
        };
      };
      virtualisation.fileSystems = {
        "/mnt/dav" = {
          device = "http://nextcloud/remote.php/dav/files/${config.adminuser}";
          fsType = "davfs";
          options = let
            davfs2Conf = (pkgs.writeText "davfs2.conf" "secrets /tmp/davfs2-secrets");
          in [ "conf=${davfs2Conf}" "x-systemd.automount" "noauto"];
        };
      };
    };

    nextcloud = { config, pkgs, ... }: {
      systemd.tmpfiles.rules = [
        "d /var/lib/nextcloud-data 0750 nextcloud nginx - -"
      ];

      services.nextcloud = {
        enable = true;
        datadir = "/var/lib/nextcloud-data";
        config.dbtableprefix = "nixos_";
        autoUpdateApps = {
          enable = true;
          startAt = "20:00";
        };
        phpExtraExtensions = all: [ all.bz2 ];
      };

      specialisation.withoutMagick.configuration = {
        services.nextcloud.enableImagemagick = false;
      };
    };
  };

  test-helpers.extraTests = { nodes, ... }: let
    findInClosure = what: drv: pkgs.runCommand "find-in-closure" { exportReferencesGraph = [ "graph" drv ]; inherit what; } ''
      test -e graph
      grep "$what" graph >$out || true
    '';
    nexcloudWithImagick = findInClosure "imagick" nodes.nextcloud.system.build.vm;
    nextcloudWithoutImagick = findInClosure "imagick" nodes.nextcloud.specialisation.withoutMagick.configuration.system.build.vm;
  in ''
    with subtest("File is in proper nextcloud home"):
        nextcloud.succeed("test -f ${nodes.nextcloud.services.nextcloud.datadir}/data/root/files/test-shared-file")

    with subtest("Closure checks"):
        assert open("${nexcloudWithImagick}").read() != ""
        assert open("${nextcloudWithoutImagick}").read() == ""

    with subtest("Davfs2"):
        assert "hi" in client.succeed("cat /mnt/dav/test-shared-file")

    with subtest("Ensure SSE is disabled by default"):
        nextcloud.succeed("grep -vE '^HBEGIN:oc_encryption_module' /var/lib/nextcloud-data/data/root/files/test-shared-file")
  '';
})
