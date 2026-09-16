# Stalwart {#module-services-stalwart}

*Source:* {file}`modules/services/stalwart/default.nix`

*Upstream documentation:* <https://stalw.art/docs>

Stalwart is an open-source mail and collaboration server designed for the modern internet.

## Running Stalwart {#module-services-stalwart-usage}

To enable Stalwart, add the following to your {file}`configuration.nix`:
```nix
{
  services.stalwart = {
    enable = true;
    package = pkgs.stalwart_0_16;
    admin = {
      enable = true;
      username = "admin";
      passwordFile = "/run/secrets/stalwart-admin-password";
    };
    url = "https://mail.example.com/";
    stateVersion = "26.11";
  };
}
```

Visit the public URL to sign in as the admin account and begin configuring your Stalwart instance.

### Databases {#module-services-stalwart-databases}

Other databases can be configured:
```nix
{
  services.stalwart.settings = {
    "@type" = "PostgreSql";
    host = "/var/run/postgresql";
    database = "stalwart";
    authUsername = "stalwart";
    authSecret."@type" = "None";
  };
  services.postgresql = {
    enable = true;
    ensureDatabase = [ "stalwart" ];
    ensureUsers = [
      {
        name = "stalwart";
        ensureDBOwnership = true;
      }
    ];
  };
}
```

For RocksDB, SQLite, FoundationDB, and MySQL, refer to [the `Datastore` object](https://stalw.art/docs/ref/object/data-store/).

## Recovery mode {#module-services-stalwart-recovery}

To enable recovery mode:
```nix
{
  services.stalwart.recovery = {
    enable = true;
    port = 8080;
  };
}
```
Recovery mode disables many checks and features that could cause problems with using Stalwart,
putting it into a state where you can use the {option}`services.stalwart.admin` account to fix it.

Do not use this in production.

## Declarative configuration {#module-services-stalwart-provision}

Use {option}`services.stalwart.provision` to declaratively configure your Stalwart instance:
```nix
{
  services.stalwart.provision =
    let
      variant = type: value: { "@type" = type; } // value;
    in
    {
      enable = true;
      url = "http://127.0.0.1:8080/";
      singletons = {
        SystemSettings = {
          defaultHostname = "example.com";
          defaultDomainId = "#main-domain";
        };
      };
      objects = {
        NetworkListener = {
          reconcile = true;
          match = [ "name" ];
          objects = {
            listener-mgmt = {
              name = "management";
              protocol = "http";
              local-port = 8080;
              tlsImplicit = false;
            };
            listener-smtp-relay = {
              name = "relay";
              protocol = "smtp";
              local-port = 25;
              tlsImplicit = false;
            };
            listener-smtp-submission = {
              name = "submission";
              protocol = "smtp";
              local-port = 465;
              tlsImplicit = true;
            };
            listener-imap = {
              name = "imap";
              protocol = "imap";
              local-port = 993;
              tlsImplicit = true;
            };
            listener-pop3 = {
              name = "pop3";
              protocol = "pop3";
              local-port = 995;
              tlsImplicit = true;
            };
            listener-sieve = {
              name = "sieve";
              protocol = "manageSieve";
              local-port = 4190;
              tlsImplicit = false;
            };
          };
        };
        Domain = {
          reconcile = true;
          match = [ "name" ];
          objects = {
            main-domain = {
              isEnabled = true;
              name = "example.com";

              catchAllAddress = "all@example.com";
              reportAddressUri = "mailto:postmaster";
              subAddressing = variant "Enabled" { };

              dnsManagement = variant "Manual" { };
              certificateManagement = variant "Manual" { };
              dkimManagement = variant "Automatic" (
                let
                  days2millis = days: 90 * 24 * 60 * 60 * 1000;
                in
                {
                  selectorTemplate = "v{version}-{algorithm}-{date-%Y%m%d}";
                  rotateAfter = days2millis 90;
                  retireAfter = days2millis 7;
                  deleteAfter = days2millis 30;
                }
              );
            };
          };
        };
        Account = {
          reconcile = false;
          match = [
            "name"
            "domainId"
          ];
          objects = {
            user-nixos = variant "User" {
              name = "nixos";
              domainId = "#main-domain";
              memberGroupIds = [ "#group-admin" ];
            };
            group-admin = variant "Group" {
              name = "admin";
              domainId = "#main-domain";
              description = "Administrators";
              roles = variant "Administrator" { };
              aliases = [
                {
                  enabled = true;
                  name = "postmaster";
                  domainId = "#main-domain";
                }
              ];
            };
          };
        };
      };
    };
  networking.firewall.allowedTCPPorts = [
    8080
    25
    465
    993
    995
    4190
  ];
}
```

Be careful with reconciling, any object not explicitly defined in an object set will be deleted after a reconcile operation.
Consider {option}`services.stalwart.provision.objects.<name>.scope` if you need to reconcile some objects of a set without affecting others.

A list of every object/singleton and their properties may be found [here](https://stalw.art/docs/ref/).

### Proxying {#module-services-stalwart-proxying}

If Stalwart is running begind a reverse proxy like Nginx or Caddy, ensure that the proxy is configured to set the `X-Forwarded-For` header to the correct value, and configure Stalwart to accept that:
`services.stalwart.provision.singletons.Http.useXForwarded = true;`

Nginx
: `services.nginx.recommendedProxySettings = true;`

Caddy
: Caddy's reverse proxy automatically sets X-Forwarded-For`

## Upgrading from 0.15.x {#module-services-stalwart-upgrading}

Stalwart underwent major breaking changes in version 0.16, please refer to [the upgrade guide](https://github.com/stalwartlabs/stalwart/blob/main/UPGRADING/v0_16.md) for more info.
