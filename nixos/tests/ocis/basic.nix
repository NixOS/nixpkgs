{
  lib,
  package,
  pkgs,
  ...
}:

let
  demoUser = "einstein";
  demoPassword = "relativity";

  rclone = pkgs.writeShellScript "ocis-rclone" ''
    set -euo pipefail
    export PATH="${lib.makeBinPath [ pkgs.rclone ]}:$PATH"
    export RCLONE_CONFIG_OCIS_TYPE=webdav
    export RCLONE_CONFIG_OCIS_VENDOR=owncloud
    export RCLONE_CONFIG_OCIS_URL=https://ocis:9200/remote.php/webdav/
    export RCLONE_CONFIG_OCIS_USER=${lib.escapeShellArg demoUser}
    export RCLONE_CONFIG_OCIS_PASS="$(rclone obscure ${lib.escapeShellArg demoPassword})"
    exec "$@"
  '';

  uploadSample = pkgs.writeShellScript "ocis-upload-sample" ''
    set -euo pipefail
    echo 'hello from ocis' | rclone --no-check-certificate rcat ocis:/test-shared-file
  '';

  checkSample = pkgs.writeShellScript "ocis-check-sample" ''
    set -euo pipefail
    diff <(echo 'hello from ocis') <(rclone --no-check-certificate cat ocis:/test-shared-file)
  '';
in
{
  meta.maintainers = with lib.maintainers; [ ramblurr ];

  nodes = {
    client = { };

    ocis = {
      networking.firewall.allowedTCPPorts = [ 9200 ];

      environment.etc."ocis/ocis.env".text = ''
        ADMIN_PASSWORD=hunter2
        IDM_CREATE_DEMO_USERS=true
      '';

      environment.etc."ocis/config/ocis.yaml".source = ./config.yaml;

      services.ocis = {
        enable = true;
        inherit package;
        configDir = "/etc/ocis/config";
        environment = {
          OCIS_INSECURE = "true";
          OCIS_URL = "https://ocis:9200";
          PROXY_ENABLE_BASIC_AUTH = "true";
          PROXY_HTTP_ADDR = "[::]:9200";
        };
        environmentFile = "/etc/ocis/ocis.env";
      };
    };
  };

  testScript = ''
    start_all()
    ocis.wait_for_unit("multi-user.target")
    ocis.wait_for_unit("ocis.service")
    ocis.wait_for_open_port(9200)

    with subtest("selected oCIS package runs"):
        ocis.succeed("${lib.getExe package} version")

    with subtest("ocisadm uses the service configuration"):
        ocis.succeed("ocisadm version")

    with subtest("upload and download through WebDAV"):
        ocis.succeed("${rclone} ${uploadSample}")
        client.succeed("${rclone} ${checkSample}")
  '';
}
