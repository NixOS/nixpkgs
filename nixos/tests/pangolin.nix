{
  lib,
  pkgs,
  ...
}:
let
  domain = "nixos.eu";
  subnet = "100.90.128.0/24";
  newtId = "this.is.the.newt.id";
  secret = "1234567890";
  orgId = "test_org_id";

  dbFilePath = "/var/lib/pangolin/config/db/db.sqlite";

in
{
  name = "pangolin";
  meta.maintainers = [ lib.maintainers.jackr ];

  # stupid mulitline strings
  skipTypeCheck = true;
  skipLint = true;

  nodes = {

    VPS = {
      imports = [ ./common/acme/client ];
      networking.domain = domain;

      environment = {
        etc = {
          "nixos/secrets/pangolin.env".text = ''
            SERVER_SECRET=${secret}
          '';
        };
        systemPackages = with pkgs; [
          fosrl-pangolin
          sqlite
          unzip
          tree
          (writeScriptBin "create-org-db" ''
            ${lib.getExe sqlite} ${dbFilePath} <<'EOF'
            INSERT INTO orgs (orgId, name, subnet)
            VALUES ('${orgId}', 'org_test_name', '${subnet}');
            EOF
          '')
          (writeScriptBin "create-site-db" ''
            ${lib.getExe sqlite} ${dbFilePath} <<'EOF'
            INSERT INTO sites (siteId, orgId, niceId, exitNode, name, type, subnet, address)
            VALUES ('1', '${orgId}', '69_Id', '1','NixOS_test_site', 'newt', '100.89.128.4/30', '${subnet}')
            EOF
          '')
        ];
      };
      # symlink badger to the right place
      # systemd.tmpfiles.settings."10-badger-link"."/var/lib/pangolin/config/traefik/local-plugins/src/github.com/fosrl".L.argument = pkgs.fosrl-badger;

      services.pangolin = {
        enable = true;
        baseDomain = domain;
        # cant use .test, since that gets caught by traefik
        letsEncryptEmail = "pangolin@${domain}";
        openFirewall = true;
        pangolinEnvironmentFile = "/etc/nixos/secrets/pangolin.env";
        settings = {
          flags.enable_integration_api = true;
        };
      };
    };

    privateHost = {
      # TODO, check if this is correct.
      # API is unclear on what's what
      environment.etc."nixos/secrets/newt.env".text = ''
        NEWT_ID=${newtId}
        NEWT_SECRET=${secret}
      '';
      services.newt = {
        enable = true;
        endpoint = domain;
        environmentFile = "/etc/secrets/nixos/newt.env"; # TODO
      };
    };

    # Fake ACME server which will respond to client requests
    acme =
      { nodes, ... }:
      {
        imports = [ ./common/acme/server ];
      };
  };
  # general idea:
  # Panglin on the VPS, and Newt in the privateHost
  # setup ACME server to sign certificates and point
  # DNS to the correct machine
  /*
    Insert stuff into the db:
    1. org -> orgs
    2. site -> sites
  */
  testScript = ''
    VPS.start()
    # privateHost.start()

    with subtest("start pangolin}"):
      VPS.wait_for_unit("pangolin.service")

    with subtest("start gerbil}"):
      VPS.wait_for_unit("gerbil.service")

    with subtest("start traefik}"):
      VPS.wait_for_unit("traefik.service")
      VPS.wait_for_open_port("7888")

    with subtest("create org and site"):
      VPS.wait_for_open_port("3004")
      VPS.succeed("create-org-db")
      VPS.succeed("create-site-db")

      VPS.succeed("sqlite3 ${dbFilePath} 'select * from orgs; select * from sites' >> /tmp/dbres")
      VPS.copy_from_vm("/tmp/dbres")
      VPS.copy_from_vm("/etc/badger")
  '';
}
