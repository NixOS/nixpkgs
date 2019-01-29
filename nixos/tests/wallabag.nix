import ./make-test.nix ({ pkgs, ...}: {
  name = "wallabag";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nadrieril ];
  };

  nodes = {
    # The only thing the client needs to do is curl
    client = { ... }: { };

    wallabag = { config, pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ 80 ];

      services.wallabag.enable = true;
      services.wallabag.hostName = "wallabag";
      services.wallabag.conf = ''
        parameters:
          domain_name: http://wallabag
          database_driver: pdo_pgsql
          database_driver_class: ~
          database_host: localhost
          database_port: null
          database_name: wallabag
          database_user: wallabag
          database_password: password
          database_path: null
          database_table_prefix: wallabag_
          database_socket: null
          database_charset: utf8
          mailer_transport: smtp
          mailer_host: 127.0.0.1
          mailer_user: null
          mailer_password: null
          locale: en
          secret: xxxxxxXXXXXXXxxxxxxxxxxxXxXxxx
          twofactor_auth: false
          twofactor_sender: no-reply@wallabag.org
          fosuser_registration: false
          fosuser_confirmation: false
          from_email: no-reply@wallabag.org
          rss_limit: 50
          rabbitmq_host: localhost
          rabbitmq_port: 5672
          rabbitmq_user: guest
          rabbitmq_password: guest
          rabbitmq_prefetch_count: 10
          redis_scheme: tcp
          redis_host: localhost
          redis_port: 6379
          redis_path: null
          redis_password: null
      '';

      services.postgresql = {
        enable = true;
        initialScript = pkgs.writeText "pgsql_initial_script" ''
          create role wallabag with login password 'password';
          create database wallabag with owner wallabag;
        '';
      };
    };
  };

  testScript = let
  in ''
    startAll();
    $wallabag->waitForUnit("multi-user.target");
    $client->waitForUnit("multi-user.target");
    $client->succeed("curl -sSf http://wallabag/login");
  '';
})
