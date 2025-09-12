{ pkgs, lib, ... }:

let
  certs = import ../common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in
{
  security.pki.certificateFiles = [ certs.ca.cert ];

  services.stalwart-mail = {
    enable = true;
    settings = {
      server.hostname = domain;

      certificate."snakeoil" = {
        cert = "%{file:${certs.${domain}.cert}}%";
        private-key = "%{file:${certs.${domain}.key}}%";
      };

      server.tls = {
        certificate = "snakeoil";
        enable = true;
        implicit = false;
      };

      server.listener = {
        "smtp-submission" = {
          bind = [ "[::]:587" ];
          protocol = "smtp";
        };

        "imap" = {
          bind = [ "[::]:143" ];
          protocol = "imap";
        };

        "http" = {
          bind = [ "[::]:80" ];
          protocol = "http";
        };
      };

      session.auth.mechanisms = "[plain]";
      session.auth.directory = "'in-memory'";
      storage.directory = "in-memory";

      storage.data = "rocksdb";
      storage.fts = "rocksdb";
      storage.blob = "rocksdb";
      storage.lookup = "rocksdb";

      session.rcpt.directory = "'in-memory'";
      queue.strategy.route = "'local'";

      store."rocksdb" = {
        type = "rocksdb";
        path = "/var/lib/stalwart-mail/data";
        compression = "lz4";
      };

      directory."in-memory" = {
        type = "memory";
        principals = [
          {
            class = "individual";
            name = "alice";
            secret = "foobar";
            email = [ "alice@${domain}" ];
          }
          {
            class = "individual";
            name = "bob";
            secret = "foobar";
            email = [ "bob@${domain}" ];
          }
        ];
      };
    };
  };

}
