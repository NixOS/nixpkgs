# parsedmarc {#module-services-parsedmarc}
[parsedmarc](https://domainaware.github.io/parsedmarc/) is a service
which parses incoming [DMARC](https://dmarc.org/) reports and stores
or sends them to a downstream service for further analysis. In
combination with Elasticsearch, Grafana and the included Grafana
dashboard, it provides a handy overview of DMARC reports over time.

## Basic usage {#module-services-parsedmarc-basic-usage}
A very minimal setup which reads incoming reports from an external
email address and saves them to a local Elasticsearch instance looks
like this:

```nix
services.parsedmarc = {
  enable = true;
  settings.imap = {
    host = "imap.example.com";
    user = "alice@example.com";
    password = "/path/to/imap_password_file";
  };
  provision.geoIp = false; # Not recommended!
};
```

Note that GeoIP provisioning is disabled in the example for
simplicity, but should be turned on for fully functional reports.

## Local mail {#module-services-parsedmarc-local-mail}
Instead of watching an external inbox, a local inbox can be
automatically provisioned. The recipient's name is by default set to
`dmarc`, but can be configured in
[services.parsedmarc.provision.localMail.recipientName](options.html#opt-services.parsedmarc.provision.localMail.recipientName). You
need to add an MX record pointing to the host. More concretely: for
the example to work, an MX record needs to be set up for
`monitoring.example.com` and the complete email address that should be
configured in the domain's dmarc policy is
`dmarc@monitoring.example.com`.

```nix
services.parsedmarc = {
  enable = true;
  provision = {
    localMail = {
      enable = true;
      hostname = monitoring.example.com;
    };
    geoIp = false; # Not recommended!
  };
};
```

## Grafana and GeoIP {#module-services-parsedmarc-grafana-geoip}
The reports can be visualized and summarized with parsedmarc's
official Grafana dashboard. For all views to work, and for the data to
be complete, GeoIP databases are also required. The following example
shows a basic deployment where the provisioned Elasticsearch instance
is automatically added as a Grafana datasource, and the dashboard is
added to Grafana as well.

```nix
services.parsedmarc = {
  enable = true;
  provision = {
    localMail = {
      enable = true;
      hostname = url;
    };
    grafana = {
      datasource = true;
      dashboard = true;
    };
  };
};

# Not required, but recommended for full functionality
services.geoipupdate = {
  settings = {
    AccountID = 000000;
    LicenseKey = "/path/to/license_key_file";
  };
};

services.grafana = {
  enable = true;
  addr = "0.0.0.0";
  domain = url;
  rootUrl = "https://" + url;
  protocol = "socket";
  security = {
    adminUser = "admin";
    adminPasswordFile = "/path/to/admin_password_file";
    secretKeyFile = "/path/to/secret_key_file";
  };
};

services.nginx = {
  enable = true;
  recommendedTlsSettings = true;
  recommendedOptimisation = true;
  recommendedGzipSettings = true;
  recommendedProxySettings = true;
  upstreams.grafana.servers."unix:/${config.services.grafana.socket}" = {};
  virtualHosts.${url} = {
    root = config.services.grafana.staticRootPath;
    enableACME = true;
    forceSSL = true;
    locations."/".tryFiles = "$uri @grafana";
    locations."@grafana".proxyPass = "http://grafana";
  };
};
users.users.nginx.extraGroups = [ "grafana" ];
```
