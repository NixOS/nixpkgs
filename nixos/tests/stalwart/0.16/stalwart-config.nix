{ lib, pkgs, ... }:

let
  certs = import ../../common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in
{
  security.pki.certificateFiles = [ certs.ca.cert ];

  services.stalwart =
    let
      variant = type: value: { "@type" = type; } // value;
    in
    {
      enable = true;
      package = pkgs.stalwart_0_16;
      openFirewall = true;
      admin = {
        enable = true;
        username = "fallback_admin";
      };
      credentials = {
        fallback_admin = toString (pkgs.writeText "super_secret_admin_password_file" "hunter2");
      };
      url = "http://${domain}/";
      stateVersion = lib.trivial.release; # Only for the test; please don't do in production

      provision = {
        enable = true;
        url = "http://machine:8080";

        singletons = {
          SystemSettings = {
            defaultHostname = domain;
            defaultDomainId = "#main-domain";
          };
          # specific patches for the test VM environment
          DnsResolver = variant "Cloudflare" { };
          SpamPyzor.enable = false;
        };
        objects = {
          NetworkListener = {
            reconcile = true;
            match = [ "name" ];
            objects =
              let
                listener = name: protocol: port: tlsImplicit: {
                  inherit name protocol tlsImplicit;
                  bind = [ "[::]:${toString port}" ];
                };
              in
              {
                management-http = listener "management" "http" 8080 false;
                smtp-relay = listener "relay" "smtp" 25 false;
                smtp-submission = listener "submission" "smtp" 465 true;
                imap = listener "imap" "imap" 993 true;
                pop3 = listener "pop3" "pop3" 995 true;
                sieve = listener "sieve" "manageSieve" 4190 false;
              };
          };
          Domain = {
            reconcile = true;
            match = [ "name" ];
            objects = {
              main-domain =
                let
                  manual = variant "Manual" { };
                in
                {
                  name = domain;

                  # certs are fake, dns isnt real, and dkim is unchecked
                  certificateManagement = manual;
                  dnsManagement = manual;
                  dkimManagement = manual;
                };
            };
          };
          Account = {
            reconcile = true;
            match = [ "name" ];
            objects = {
              user-alice = variant "User" {
                name = "alice";
                domainId = "#main-domain";
                credentials = [
                  # would've gone with foobar, but stalwart rejects it because it's too short, and is too similar to common passwords. keysamash + number + digit to be safe
                  (variant "Password" { secret = "Aslkjfvnskdjfbn1!"; })
                ];
              };
              user-bob = variant "User" {
                name = "bob";
                domainId = "#main-domain";
                credentials = [
                  (variant "Password" { secret = "Ogisdhlbjknsgfbn1!"; })
                ];
              };
            };
          };
          Tracer = {
            reconcile = true;
            match = [ "@type" ];
            objects = {
              journal = variant "Journal" {
                enable = true;
                level = "debug";
              };
            };
          };
        };
      };
    };

}
