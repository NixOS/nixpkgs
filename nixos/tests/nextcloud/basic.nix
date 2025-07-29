{
  name,
  pkgs,
  testBase,
  system,
  ...
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };
runTest (
  { config, lib, ... }:
  {
    inherit name;
    meta = {
      maintainers = lib.teams.nextcloud.members;
    };

    imports = [ testBase ];

    nodes = {
      # The only thing the client needs to do is download a file.
      client =
        { ... }:
        {
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
              options =
                let
                  davfs2Conf = (pkgs.writeText "davfs2.conf" "secrets /tmp/davfs2-secrets");
                in
                [
                  "conf=${davfs2Conf}"
                  "x-systemd.automount"
                  "noauto"
                ];
            };
          };
        };

      nextcloud =
        { config, pkgs, ... }:
        {
          systemd.tmpfiles.rules = [
            "d /var/lib/nextcloud-data 0750 nextcloud nginx - -"
          ];

          services.nextcloud = {
            enable = true;
            config.dbtype = "sqlite";
            datadir = "/var/lib/nextcloud-data";
            autoUpdateApps = {
              enable = true;
              startAt = "20:00";
            };
            phpExtraExtensions = all: [ all.bz2 ];
            nginx.enableFastcgiRequestBuffering = true;
          };

          specialisation.withoutMagick.configuration = {
            services.nextcloud.enableImagemagick = false;
          };
        };
    };

    test-helpers.extraTests =
      { nodes, ... }:
      let
        findInClosure =
          what: drv:
          pkgs.runCommand "find-in-closure"
            {
              exportReferencesGraph = [
                "graph"
                drv
              ];
              inherit what;
            }
            ''
              test -e graph
              grep "$what" graph >$out || true
            '';
        nexcloudWithImagick = findInClosure "imagick" nodes.nextcloud.system.build.vm;
        nextcloudWithoutImagick = findInClosure "imagick" nodes.nextcloud.specialisation.withoutMagick.configuration.system.build.vm;
      in
      # python
      ''
        with subtest("File is in proper nextcloud home"):
            nextcloud.succeed("test -f ${nodes.nextcloud.services.nextcloud.datadir}/data/root/files/test-shared-file")

        with subtest("Closure checks"):
            assert open("${nexcloudWithImagick}").read() != ""
            assert open("${nextcloudWithoutImagick}").read() == ""

        with subtest("Davfs2"):
            assert "hi" in client.succeed("cat /mnt/dav/test-shared-file")

        with subtest("Ensure SSE is disabled by default"):
            nextcloud.succeed("grep -vE '^HBEGIN:oc_encryption_module' /var/lib/nextcloud-data/data/root/files/test-shared-file")

        with subtest("Create non-empty files with Transfer-Encoding: chunked"):
            client.succeed(
              'dd if=/dev/urandom of=testfile.bin bs=1M count=10',
              'curl --fail -v -X PUT --header "Transfer-Encoding: chunked" --data-binary @testfile.bin "http://nextcloud/remote.php/webdav/testfile.bin" -u ${config.adminuser}:${config.adminpass}',
            )

            # Verify the local and remote copies of the file are identical.
            client_hash = client.succeed("nix-hash testfile.bin").strip()
            nextcloud_hash = nextcloud.succeed("nix-hash /var/lib/nextcloud-data/data/root/files/testfile.bin").strip()
            t.assertEqual(client_hash, nextcloud_hash)
      '';
  }
)
