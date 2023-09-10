args@{ pkgs, nextcloudVersion ? 25, ... }:

(import ../make-test-python.nix ({ pkgs, ...}: let
  adminuser = "root";
  adminpass = "notproduction";
  nextcloudBase = {
    networking.firewall.allowedTCPPorts = [ 80 ];
    system.stateVersion = "22.05"; # stateVersions <22.11 use openssl 1.1 by default
    services.nextcloud = {
      enable = true;
      config.adminpassFile = "${pkgs.writeText "adminpass" adminpass}";
      database.createLocally = true;
      package = pkgs.${"nextcloud" + (toString nextcloudVersion)};
    };
  };
in {
  name = "nextcloud-openssl";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ma27 ];
  };
  nodes.nextcloudwithopenssl1 = {
    imports = [ nextcloudBase ];
    services.nextcloud.hostName = "nextcloudwithopenssl1";
  };
  nodes.nextcloudwithopenssl3 = {
    imports = [ nextcloudBase ];
    services.nextcloud = {
      hostName = "nextcloudwithopenssl3";
      enableBrokenCiphersForSSE = false;
    };
  };
  testScript = { nodes, ... }: let
    withRcloneEnv = host: pkgs.writeScript "with-rclone-env" ''
      #!${pkgs.runtimeShell}
      export RCLONE_CONFIG_NEXTCLOUD_TYPE=webdav
      export RCLONE_CONFIG_NEXTCLOUD_URL="http://${host}/remote.php/dav/files/${adminuser}"
      export RCLONE_CONFIG_NEXTCLOUD_VENDOR="nextcloud"
      export RCLONE_CONFIG_NEXTCLOUD_USER="${adminuser}"
      export RCLONE_CONFIG_NEXTCLOUD_PASS="$(${pkgs.rclone}/bin/rclone obscure ${adminpass})"
      "''${@}"
    '';
    withRcloneEnv1 = withRcloneEnv "nextcloudwithopenssl1";
    withRcloneEnv3 = withRcloneEnv "nextcloudwithopenssl3";
    copySharedFile1 = pkgs.writeScript "copy-shared-file" ''
      #!${pkgs.runtimeShell}
      echo 'hi' | ${withRcloneEnv1} ${pkgs.rclone}/bin/rclone rcat nextcloud:test-shared-file
    '';
    copySharedFile3 = pkgs.writeScript "copy-shared-file" ''
      #!${pkgs.runtimeShell}
      echo 'bye' | ${withRcloneEnv3} ${pkgs.rclone}/bin/rclone rcat nextcloud:test-shared-file2
    '';
    openssl1-node = nodes.nextcloudwithopenssl1.system.build.toplevel;
    openssl3-node = nodes.nextcloudwithopenssl3.system.build.toplevel;
  in ''
    nextcloudwithopenssl1.start()
    nextcloudwithopenssl1.wait_for_unit("multi-user.target")
    nextcloudwithopenssl1.succeed("nextcloud-occ status")
    nextcloudwithopenssl1.succeed("curl -sSf http://nextcloudwithopenssl1/login")
    nextcloud_version = ${toString nextcloudVersion}

    with subtest("With OpenSSL 1 SSE can be enabled and used"):
        nextcloudwithopenssl1.succeed("nextcloud-occ app:enable encryption")
        nextcloudwithopenssl1.succeed("nextcloud-occ encryption:enable")

    with subtest("Upload file and ensure it's encrypted"):
        nextcloudwithopenssl1.succeed("${copySharedFile1}")
        nextcloudwithopenssl1.succeed("grep -E '^HBEGIN:oc_encryption_module' /var/lib/nextcloud/data/root/files/test-shared-file")
        nextcloudwithopenssl1.succeed("${withRcloneEnv1} ${pkgs.rclone}/bin/rclone cat nextcloud:test-shared-file | grep hi")

    with subtest("Switch to OpenSSL 3"):
        nextcloudwithopenssl1.succeed("${openssl3-node}/bin/switch-to-configuration test")
        nextcloudwithopenssl1.wait_for_open_port(80)
        nextcloudwithopenssl1.succeed("nextcloud-occ status")

    with subtest("Existing encrypted files cannot be read, but new files can be added"):
        # This will succeed starting NC26 because of their custom implementation of openssl_seal
        read_existing_file_test = nextcloudwithopenssl1.fail if nextcloud_version < 26 else nextcloudwithopenssl1.succeed
        read_existing_file_test("${withRcloneEnv3} ${pkgs.rclone}/bin/rclone cat nextcloud:test-shared-file >&2")
        nextcloudwithopenssl1.succeed("nextcloud-occ encryption:disable")
        nextcloudwithopenssl1.succeed("${copySharedFile3}")
        nextcloudwithopenssl1.succeed("grep bye /var/lib/nextcloud/data/root/files/test-shared-file2")
        nextcloudwithopenssl1.succeed("${withRcloneEnv3} ${pkgs.rclone}/bin/rclone cat nextcloud:test-shared-file2 | grep bye")

    with subtest("Switch back to OpenSSL 1.1 and ensure that encrypted files are readable again"):
        nextcloudwithopenssl1.succeed("${openssl1-node}/bin/switch-to-configuration test")
        nextcloudwithopenssl1.wait_for_open_port(80)
        nextcloudwithopenssl1.succeed("nextcloud-occ status")
        nextcloudwithopenssl1.succeed("nextcloud-occ encryption:enable")
        nextcloudwithopenssl1.succeed("${withRcloneEnv1} ${pkgs.rclone}/bin/rclone cat nextcloud:test-shared-file2 | grep bye")
        nextcloudwithopenssl1.succeed("${withRcloneEnv1} ${pkgs.rclone}/bin/rclone cat nextcloud:test-shared-file | grep hi")
        nextcloudwithopenssl1.succeed("grep -E '^HBEGIN:oc_encryption_module' /var/lib/nextcloud/data/root/files/test-shared-file")
        nextcloudwithopenssl1.succeed("grep bye /var/lib/nextcloud/data/root/files/test-shared-file2")

    with subtest("Ensure that everything can be decrypted"):
        nextcloudwithopenssl1.succeed("echo y | nextcloud-occ encryption:decrypt-all >&2")
        nextcloudwithopenssl1.succeed("${withRcloneEnv1} ${pkgs.rclone}/bin/rclone cat nextcloud:test-shared-file2 | grep bye")
        nextcloudwithopenssl1.succeed("${withRcloneEnv1} ${pkgs.rclone}/bin/rclone cat nextcloud:test-shared-file | grep hi")
        nextcloudwithopenssl1.succeed("grep -vE '^HBEGIN:oc_encryption_module' /var/lib/nextcloud/data/root/files/test-shared-file")

    with subtest("Switch to OpenSSL 3 ensure that all files are usable now"):
        nextcloudwithopenssl1.succeed("${openssl3-node}/bin/switch-to-configuration test")
        nextcloudwithopenssl1.wait_for_open_port(80)
        nextcloudwithopenssl1.succeed("nextcloud-occ status")
        nextcloudwithopenssl1.succeed("${withRcloneEnv3} ${pkgs.rclone}/bin/rclone cat nextcloud:test-shared-file2 | grep bye")
        nextcloudwithopenssl1.succeed("${withRcloneEnv3} ${pkgs.rclone}/bin/rclone cat nextcloud:test-shared-file | grep hi")

    nextcloudwithopenssl1.shutdown()
  '';
})) args
