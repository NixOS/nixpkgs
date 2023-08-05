# GoToSocial {#module-services-gotosocial}

[GoToSocial](https://gotosocial.org/) is an ActivityPub social network server, written in Golang.

## Service configuration {#modules-services-gotosocial-service-configuration}

The following configuration sets up the PostgreSQL as database backend and binds
GoToSocial to `127.0.0.1:8080`, expecting to be run behind a HTTP proxy on `gotosocial.example.com`.

```nix
services.gotosocial = {
  enable = true;
  setupPostgresqlDB = true;
  settings = {
    application-name = "My GoToSocial";
    host = "gotosocial.example.com";
    protocol = "https";
    bind-address = "127.0.0.1";
    port = 8080;
  };
};
```

Please refer to the [GoToSocial Documentation](https://docs.gotosocial.org/en/latest/configuration/general/)
for additional configuration options.

## Proxy configuration {#modules-services-gotosocial-proxy-configuration}

Although it is possible to expose GoToSocial directly, it is common practice to operate it behind an
HTTP reverse proxy such as nginx.

```nix
networking.firewall.allowedTCPPorts = [ 80 443 ];
services.nginx = {
  enable = true;
  clientMaxBodySize = "40M";
  virtualHosts = with config.services.gotosocial.settings; {
    "${host}" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "http://${bind-address}:${toString port}";
        };
      };
    };
  };
};
```

Please refer to [](#module-security-acme) for details on how to provision an SSL/TLS certificate.

## User management {#modules-services-gotosocial-user-management}

After the GoToSocial service is running, the `gotosocial-admin` utility can be used to manage users. In particular an
administrative user can be created with

```ShellSession
$ sudo gotosocial-admin account create --username <nickname> --email <email> --password <password>
$ sudo gotosocial-admin account confirm --username <nickname>
$ sudo gotosocial-admin account promote --username <nickname>
```
