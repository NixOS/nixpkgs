{ lib, ... }:
{
  name = "rauthy";
  meta.maintainers = with lib.maintainers; [
    gepbird
  ];

  nodes.machine =
    { config, pkgs, ... }:
    let
      # Do not use this in production. This will make the secret world-readable
      # in the Nix store
      secrets = {
        rauthy-secret-api.path = builtins.toString (
          pkgs.writeText "rauthy-secret-api" "SuperSecureSecret1337"
        );
        rauthy-secret-raft.path = builtins.toString (
          pkgs.writeText "rauthy-secret-raft" "SuperSecureSecret1337"
        );
      };
    in
    {
      services.rauthy = {
        enable = true;
        settings = {
          bootstrap = {
            admin_email = "admin@localhost";
          };
          cluster = {
            node_id = 1;
            nodes = [ "1 localhost:8100 localhost:8200" ];
            secret_api._secret_path = secrets.rauthy-secret-api.path;
            secret_raft._secret_path = secrets.rauthy-secret-raft.path;
          };
          email = {
            smtp_from = "Rauthy <rauthy@localhost>";
            smtp_password = "password";
            smtp_url = "localhost";
            smtp_username = "username";
          };
          encryption = {
            key_active = "q6u26";
            keys = [ "q6u26/M0NFQzhSSldCY01rckJNa1JYZ3g2NUFtSnNOVGdoU0E=" ];
          };
          events = {
            email = "admin@localhost";
          };
          server = {
            proxy_mode = false;
            pub_url = "localhost:8080";
            scheme = "http";
          };
          webauthn = {
            rp_id = "localhost";
            rp_origin = "http://localhost:5173";
          };
        };
      };

      services.postfix =
        let
          domainName = "localhost";
        in
        {
          enable = true;
          settings = {
            main = {
              myhostname = domainName;
              mydestination = "${domainName}, localhost";
              mynetworks_style = "host";
              smtpd_tls_security_level = "may"; # Enable TLS if available
              smtpd_tls_chain_files = [ ]; # Add your certificate files here if you need secure SMTP
              smtp_tls_security_level = "may"; # Enables TLS for outgoing emails if available
              smtp_tls_CAfile = config.security.pki.caBundle;
              # Optionally, allow local recipients
              local_recipient_maps = null;
            };
          };

          # Optionally, you might want to open the SMTP port for local connections.
          enableSubmission = true;
          setSendmail = true;

          user = "postfix";
          group = "postfix";
          setgidGroup = "postdrop";
          postmasterAlias = "postmaster";
          rootAlias = "root@localhost";
        };
    };

  # TODO: write asserts, maybe add a mail server so it doesnt crash?
  testScript = ''
    machine.wait_for_unit("rauthy.service")
    machine.succeed("sleep 5")
  '';
}
