args@{ pkgs, nextcloudVersion ? 22, ... }:

(import ../make-test-python.nix ({ pkgs, ...}: let
  adminpass = "notproduction";
  adminuser = "root";
in {
  name = "nextcloud-basic";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ globin eqyiel ];
  };

  nodes = rec {
    # The only thing the client needs to do is download a file.
    client = { ... }: {
      services.davfs2.enable = true;
      system.activationScripts.davfs2-secrets = ''
        echo "http://nextcloud/remote.php/webdav/ ${adminuser} ${adminpass}" > /tmp/davfs2-secrets
        chmod 600 /tmp/davfs2-secrets
      '';
      virtualisation.fileSystems = {
        "/mnt/dav" = {
          device = "http://nextcloud/remote.php/webdav/";
          fsType = "davfs";
          options = let
            davfs2Conf = (pkgs.writeText "davfs2.conf" "secrets /tmp/davfs2-secrets");
          in [ "conf=${davfs2Conf}" "x-systemd.automount" "noauto"];
        };
      };
    };

    nextcloud = { config, pkgs, ... }: let
      cfg = config;
    in {
      networking.firewall.allowedTCPPorts = [ 80 ];

      systemd.tmpfiles.rules = [
        "d /var/lib/nextcloud-data 0750 nextcloud nginx - -"
      ];

      system.stateVersion = "22.11"; # stateVersion >=21.11 to make sure that we use OpenSSL3

      services.nextcloud = {
        enable = true;
        datadir = "/var/lib/nextcloud-data";
        hostName = "nextcloud";
        config = {
          # Don't inherit adminuser since "root" is supposed to be the default
          adminpassFile = "${pkgs.writeText "adminpass" adminpass}"; # Don't try this at home!
          dbtableprefix = "nixos_";
        };
        package = pkgs.${"nextcloud" + (toString nextcloudVersion)};
        autoUpdateApps = {
          enable = true;
          startAt = "20:00";
        };
        phpExtraExtensions = all: [ all.bz2 ];
      };

      environment.systemPackages = [ cfg.services.nextcloud.occ ];
    };

    nextcloudWithoutMagick = args@{ config, pkgs, lib, ... }:
      lib.mkMerge
      [ (nextcloud args)
        { services.nextcloud.enableImagemagick = false; } ];
  };

  testScript = { nodes, ... }: let
    withRcloneEnv = pkgs.writeScript "with-rclone-env" ''
      #!${pkgs.runtimeShell}
      export RCLONE_CONFIG_NEXTCLOUD_TYPE=webdav
      export RCLONE_CONFIG_NEXTCLOUD_URL="http://nextcloud/remote.php/webdav/"
      export RCLONE_CONFIG_NEXTCLOUD_VENDOR="nextcloud"
      export RCLONE_CONFIG_NEXTCLOUD_USER="${adminuser}"
      export RCLONE_CONFIG_NEXTCLOUD_PASS="$(${pkgs.rclone}/bin/rclone obscure ${adminpass})"
      "''${@}"
    '';
    copySharedFile = pkgs.writeScript "copy-shared-file" ''
      #!${pkgs.runtimeShell}
      echo 'hi' | ${withRcloneEnv} ${pkgs.rclone}/bin/rclone rcat nextcloud:test-shared-file
    '';

    diffSharedFile = pkgs.writeScript "diff-shared-file" ''
      #!${pkgs.runtimeShell}
      diff <(echo 'hi') <(${pkgs.rclone}/bin/rclone cat nextcloud:test-shared-file)
    '';

    findInClosure = what: drv: pkgs.runCommand "find-in-closure" { exportReferencesGraph = [ "graph" drv ]; inherit what; } ''
      test -e graph
      grep "$what" graph >$out || true
    '';
    nextcloudUsesImagick = findInClosure "imagick" nodes.nextcloud.config.system.build.vm;
    nextcloudWithoutDoesntUseIt = findInClosure "imagick" nodes.nextcloudWithoutMagick.config.system.build.vm;
  in ''
    assert open("${nextcloudUsesImagick}").read() != ""
    assert open("${nextcloudWithoutDoesntUseIt}").read() == ""

    nextcloud.start()
    client.start()
    nextcloud.wait_for_unit("multi-user.target")
    # This is just to ensure the nextcloud-occ program is working
    nextcloud.succeed("nextcloud-occ status")
    nextcloud.succeed("curl -sSf http://nextcloud/login")
    # Ensure that no OpenSSL 1.1 is used.
    nextcloud.succeed(
        "${nodes.nextcloud.services.phpfpm.pools.nextcloud.phpPackage}/bin/php -i | grep 'OpenSSL Library Version' | awk -F'=>' '{ print $2 }' | awk '{ print $2 }' | grep -v 1.1"
    )
    nextcloud.succeed(
        "${withRcloneEnv} ${copySharedFile}"
    )
    client.wait_for_unit("multi-user.target")
    nextcloud.succeed("test -f /var/lib/nextcloud-data/data/root/files/test-shared-file")
    client.succeed(
        "${withRcloneEnv} ${diffSharedFile}"
    )
    assert "hi" in client.succeed("cat /mnt/dav/test-shared-file")
    nextcloud.succeed("grep -vE '^HBEGIN:oc_encryption_module' /var/lib/nextcloud-data/data/root/files/test-shared-file")
  '';
})) args
