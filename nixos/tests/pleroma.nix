/*
  Pleroma E2E VM test.

  Abstract:
  =========
  Using pleroma, postgresql, a local CA cert, a nginx reverse proxy
  and a toot-based client, we're going to:

  1. Provision a pleroma service from scratch (pleroma config + postgres db).
  2. Create a "jamy" admin user.
  3. Send a toot from this user.
  4. Send a upload from this user.
  5. Check the toot is part of the server public timeline

  Notes:
  - We need a fully functional TLS setup without having any access to
    the internet. We do that by issuing a self-signed cert, add this
    self-cert to the hosts pki trust store and finally spoof the
    hostnames using /etc/hosts.
  - For this NixOS test, we *had* to store some DB-related and
    pleroma-related secrets to the store. Keep in mind the store is
    world-readable, it's the worst place possible to store *any*
    secret. **DO NOT DO THIS IN A REAL WORLD DEPLOYMENT**.
*/

import ./make-test-python.nix ({ pkgs, ... }:
  let
  send-toot = pkgs.writeScriptBin "send-toot" ''
    set -eux
    # toot is using the requests library internally. This library
    # sadly embed its own certificate store instead of relying on the
    # system one. Overriding this pretty bad default behaviour.
    export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

    echo "jamy-password" | toot login_cli -i "pleroma.nixos.test" -e "jamy@nixos.test"
    echo "Login OK"

    # Send a toot then verify it's part of the public timeline
    echo "y" | toot post "hello world Jamy here"
    echo "Send toot OK"
    echo "y" | toot timeline | grep -c "hello world Jamy here"
    echo "Get toot from timeline OK"

    # Test file upload
    echo "y" | toot upload ${db-seed} | grep -c "https://pleroma.nixos.test/media"
    echo "File upload OK"

    echo "====================================================="
    echo "=                   SUCCESS                         ="
    echo "=                                                   ="
    echo "=    We were able to sent a toot + a upload and     ="
    echo "=   retrieve both of them in the public timeline.   ="
    echo "====================================================="
  '';

  provision-db = pkgs.writeScriptBin "provision-db" ''
    set -eux
    sudo -u postgres psql -f ${db-seed}
  '';

  test-db-passwd = "SccZOvTGM//BMrpoQj68JJkjDkMGb4pHv2cECWiI+XhVe3uGJTLI0vFV/gDlZ5jJ";

  /* For this NixOS test, we *had* to store this secret to the store.
    Keep in mind the store is world-readable, it's the worst place
    possible to store *any* secret. **DO NOT DO THIS IN A REAL WORLD
    DEPLOYMENT**.*/
  db-seed = pkgs.writeText "provision.psql" ''
    CREATE USER pleroma WITH ENCRYPTED PASSWORD '${test-db-passwd}';
    CREATE DATABASE pleroma OWNER pleroma;
    \c pleroma;
    --Extensions made by ecto.migrate that need superuser access
    CREATE EXTENSION IF NOT EXISTS citext;
    CREATE EXTENSION IF NOT EXISTS pg_trgm;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
  '';

  pleroma-conf = ''
    import Config

    config :pleroma, Pleroma.Web.Endpoint,
       url: [host: "pleroma.nixos.test", scheme: "https", port: 443],
       http: [ip: {127, 0, 0, 1}, port: 4000]

    config :pleroma, :instance,
      name: "NixOS test pleroma server",
      email: "pleroma@nixos.test",
      notify_email: "pleroma@nixos.test",
      limit: 5000,
      registrations_open: true

    config :pleroma, :media_proxy,
      enabled: false,
      redirect_on_failure: true
      #base_url: "https://cache.pleroma.social"

    config :pleroma, Pleroma.Repo,
      adapter: Ecto.Adapters.Postgres,
      username: "pleroma",
      password: "${test-db-passwd}",
      database: "pleroma",
      hostname: "localhost",
      pool_size: 10,
      prepare: :named,
      parameters: [
        plan_cache_mode: "force_custom_plan"
      ]

    config :pleroma, :database, rum_enabled: false
    config :pleroma, :instance, static_dir: "/var/lib/pleroma/static"
    config :pleroma, Pleroma.Uploaders.Local, uploads: "/var/lib/pleroma/uploads"
    config :pleroma, configurable_from_database: false
  '';

  /* For this NixOS test, we *had* to store this secret to the store.
    Keep in mind the store is world-readable, it's the worst place
    possible to store *any* secret. **DO NOT DO THIS IN A REAL WORLD
    DEPLOYMENT**.
    In a real-word deployment, you'd handle this either by:
    - manually upload your pleroma secrets to /var/lib/pleroma/secrets.exs
    - use a deployment tool such as morph or NixOps to deploy your secrets.
  */
  pleroma-conf-secret = pkgs.writeText "secrets.exs" ''
    import Config

    config :joken, default_signer: "PS69/wMW7X6FIQPABt9lwvlZvgrJIncfiAMrK9J5mjVus/7/NJJi1DsDA1OghBE5"

    config :pleroma, Pleroma.Web.Endpoint,
       secret_key_base: "NvfmU7lYaQrmmxt4NACm0AaAfN9t6WxsrX0NCB4awkGHvr1S7jyshlEmrjaPFhhq",
       signing_salt: "3L41+BuJ"

    config :web_push_encryption, :vapid_details,
      subject: "mailto:pleroma@nixos.test",
      public_key: "BKjfNX9-UqAcncaNqERQtF7n9pKrB0-MO-juv6U5E5XQr_Tg5D-f8AlRjduAguDpyAngeDzG8MdrTejMSL4VF30",
      private_key: "k7o9onKMQrgMjMb6l4fsxSaXO0BTNAer5MVSje3q60k"
  '';

  /* For this NixOS test, we *had* to store this secret to the store.
    Keep in mind the store is world-readable, it's the worst place
    possible to store *any* secret. **DO NOT DO THIS IN A REAL WORLD
    DEPLOYMENT**.
    In a real-word deployment, you'd handle this either by:
    - manually upload your pleroma secrets to /var/lib/pleroma/secrets.exs
    - use a deployment tool such as morph or NixOps to deploy your secrets.
    */
  provision-secrets = pkgs.writeScriptBin "provision-secrets" ''
    set -eux
    cp "${pleroma-conf-secret}" "/var/lib/pleroma/secrets.exs"
    chown pleroma:pleroma /var/lib/pleroma/secrets.exs
  '';

  /* For this NixOS test, we *had* to store this secret to the store.
    Keep in mind the store is world-readable, it's the worst place
    possible to store *any* secret. **DO NOT DO THIS IN A REAL WORLD
    DEPLOYMENT**.
  */
  provision-user = pkgs.writeScriptBin "provision-user" ''
    set -eux

    # Waiting for pleroma to be up.
    timeout 5m bash -c 'while [[ "$(curl -s -o /dev/null -w '%{http_code}' https://pleroma.nixos.test/api/v1/instance)" != "200" ]]; do sleep 2; done'
    # Toremove the RELEASE_COOKIE bit when https://github.com/NixOS/nixpkgs/issues/166229 gets fixed.
    RELEASE_COOKIE="/var/lib/pleroma/.cookie" \
      pleroma_ctl user new jamy jamy@nixos.test --password 'jamy-password' --moderator --admin -y
  '';

  tls-cert = pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -subj '/CN=pleroma.nixos.test' -days 36500
    mkdir -p $out
    cp key.pem cert.pem $out
  '';

  hosts = nodes: ''
    ${nodes.pleroma.config.networking.primaryIPAddress} pleroma.nixos.test
    ${nodes.client.config.networking.primaryIPAddress} client.nixos.test
  '';
  in {
  name = "pleroma";
  nodes = {
    client = { nodes, pkgs, config, ... }: {
      security.pki.certificateFiles = [ "${tls-cert}/cert.pem" ];
      networking.extraHosts = hosts nodes;
      environment.systemPackages = with pkgs; [
        toot
        send-toot
      ];
    };
    pleroma = { nodes, pkgs, config, ... }: {
      security.pki.certificateFiles = [ "${tls-cert}/cert.pem" ];
      networking.extraHosts = hosts nodes;
      networking.firewall.enable = false;
      environment.systemPackages = with pkgs; [
        provision-db
        provision-secrets
        provision-user
      ];
      services = {
        pleroma = {
          enable = true;
          configs = [
            pleroma-conf
          ];
        };
        postgresql = {
          enable = true;
          package = pkgs.postgresql_12;
        };
        nginx = {
          enable = true;
          virtualHosts."pleroma.nixos.test" = {
            addSSL = true;
            sslCertificate = "${tls-cert}/cert.pem";
            sslCertificateKey = "${tls-cert}/key.pem";
            locations."/" = {
              proxyPass = "http://127.0.0.1:4000";
              extraConfig = ''
                add_header 'Access-Control-Allow-Origin' '*' always;
                add_header 'Access-Control-Allow-Methods' 'POST, PUT, DELETE, GET, PATCH, OPTIONS' always;
                add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type, Idempotency-Key' always;
                add_header 'Access-Control-Expose-Headers' 'Link, X-RateLimit-Reset, X-RateLimit-Limit, X-RateLimit-Remaining, X-Request-Id' always;
                if ($request_method = OPTIONS) {
                    return 204;
                }
                add_header X-XSS-Protection "1; mode=block";
                add_header X-Permitted-Cross-Domain-Policies none;
                add_header X-Frame-Options DENY;
                add_header X-Content-Type-Options nosniff;
                add_header Referrer-Policy same-origin;
                add_header X-Download-Options noopen;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
                proxy_set_header Host $host;
                client_max_body_size 16m;
              '';
            };
          };
        };
      };
    };
  };

  testScript = { nodes, ... }: ''
    pleroma.wait_for_unit("postgresql.service")
    pleroma.succeed("provision-db")
    pleroma.succeed("provision-secrets")
    pleroma.systemctl("restart pleroma.service")
    pleroma.wait_for_unit("pleroma.service")
    pleroma.succeed("provision-user")
    client.succeed("send-toot")
  '';
})
