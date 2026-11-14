# Mitmdump {#module-services-mitmdump}

[mitmproxy][] is a set of tools that provide an interactive, SSL/TLS-capable intercepting proxy for HTTP/1, HTTP/2, and WebSockets.
[mitmdump][] is the command-line non-interactive version of mitmproxy.

This module sets up one or multiple instances of mitmdump.

By default it uses [reverse proxy][] mode
which allows to intercept network traffic and dump the HTTP requests and responses.
Use it to debug interaction between two services.

[mitmproxy]: https://docs.mitmproxy.org/stable
[mitmdump]: https://plattner.me/mp-docs/#mitmdump
[reverse proxy]: https://plattner.me/mp-docs/concepts-modes/#reverse-proxy

Each `mitmdump` instance has its own systemd service which is only considered started
when the mitmdump instance has started listening on the expected port.

Addons can be enabled with the `enabledAddons` option.

## Usage {#module-services-mitmdump-usage}

Set up an mitmdump instance listening on port 8001
which sits in front of a server listening on port 8000.
In this example, the server is a plain nginx service
that always answers the static text `content`.

```nix
{
  services.mitmdump.instances."base" = {
    listenPort = 8001;
    upstreamPort = 8000;
    after = [ "nginx.service" ];
  };

  services.nginx = {
    enable = true;
    virtualHosts."server" = {
      default = true;
      listen = [
        {
          addr = "0.0.0.0";
          port = 8000;
        }
      ];
      locations."/" = {
        return = "200 content";
        extraConfig = "default_type text/plain;";
      };
    };
  };
}
```

The corresponding systemd service for the mitmdump proxy is `mitmdump-base.service`.

```
$ curl -H 'my-header: test' http://127.0.0.1:8001

$ journalctl -u mitmdump-base

mitmdump[884]: 127.0.0.1:42916: GET http://127.0.0.1:8000/
mitmdump[884]:               << 200 OK 7b
```

By default, only the response status and size are shown.
See below for how to also print the request and response headers and request and response bodies.

### Increased Logging {#module-services-mitmdump-usage-increased-logging}

To print request and response bodies and headers, increase the logging level
with the `flow_detail` option in `extraArgs`:

```nix
{
  services.mitmdump.instances."detailed" = {
    listenPort = 8002;
    upstreamPort = 8000;
    after = [ "nginx.service" ];
    extraArgs = [
      "--set"
      "flow_detail=3"
      "--set"
      "content_view_lines_cutoff=2000"
    ];
  };
}
```

The default `flow_details` is 1. See the [mitmdump manual][] for more explanations on the options
and their values.

[mitmdump manual]: https://docs.mitmproxy.org/stable/concepts/options/

It is a good idea to also include the `content_view_lines_cutoff` option to avoid logging an
unwanted huge request.

```
$ curl -H 'my-header: test' http://127.0.0.1:8002

$ journalctl -u mitmdump-detailed

mitmdump[885]: 127.0.0.1:51400: GET http://127.0.0.1:8000/
mitmdump[885]:     Host: 127.0.0.1:8000
mitmdump[885]:     User-Agent: curl/8.22.0
mitmdump[885]:     Accept: */*
mitmdump[885]:     my-header: test
mitmdump[885]:  << 200 OK 7b
mitmdump[885]:     Server: nginx
mitmdump[885]:     Date: Mon, 09 Nov 2026 19:50:52 GMT
mitmdump[885]:     Content-Type: text/plain
mitmdump[885]:     Content-Length: 7
mitmdump[885]:     Connection: keep-alive
mitmdump[885]:     content
```

This will change the verbosity for all requests and responses.
If you want to only enable verbose logging for some paths, see the following section.

### Filtered Detailed Logging {#module-services-mitmdump-usage-filtered-logging}

For this feature, the Fine Grained Logger addon must be enabled.
Enabling this addon will add the `mitmdump` option `verbose_pattern` which takes a regex,
and only prints the request and response headers and body if it matches.
If it does not match, it will just print the response status ans size.

The following config will make mitmdump show verbose info for all paths matching the `/verbose` regex.
It matches anywhere in the path:

```nix
{
  services.mitmdump.instances."filtered" = {
    listenPort = 8003;
    upstreamPort = 8000;
    after = [ "nginx.service" ];
    enabledAddons = [ config.services.mitmdump.addons.logger ];
    extraArgs = [
      "--set"
      "verbose_pattern=/verbose"
      "--set"
      "content_view_lines_cutoff=2000"
    ];
  };
}
```

A `GET` request to `/notverbose` will print:

```
$ curl -H 'my-header: test' http://127.0.0.1:8003/notverbose

$ journalctl -u mitmdump-filtered

mitmdump[886]: 127.0.0.1:43440: GET http://127.0.0.1:8000/notverbose
mitmdump[886]:               << 200 OK 7b
```

While a `GET` request to `/asdf/verboseasdf` will print the full info:

```
$ curl -H 'my-header: test' http://127.0.0.1:8003/asdf/verboseasdf

$ journalctl -u mitmdump-filtered

mitmdump[886]: 127.0.0.1:38882: GET http://127.0.0.1:8000/asdf/verboseasdf
mitmdump[886]: RequestHeaders:
mitmdump[886]:     Host: 127.0.0.1:8000
mitmdump[886]:     User-Agent: curl/8.22.0
mitmdump[886]:     Accept: */*
mitmdump[886]:     my-header: test
mitmdump[886]: RequestBody:
mitmdump[886]: Status:          200
mitmdump[886]: ResponseHeaders:
mitmdump[886]:     Server: nginx
mitmdump[886]:     Date: Mon, 09 Nov 2026 19:56:20 GMT
mitmdump[886]:     Content-Type: text/plain
mitmdump[886]:     Content-Length: 7
mitmdump[886]:     Connection: keep-alive
mitmdump[886]: ResponseBody:    content
mitmdump[886]:               << 200 OK 7b
```

### Remote Host {#module-services-mitmdump-usage-remote-host}

Put mitmdump in front of a HTTP server listening on port 8000 on another host:

```nix
{
  services.mitmdump.instances."remote" = {
    listenPort = 8004;
    upstreamHost = "http://127.0.0.1";
    upstreamPort = 8000;
    after = [ "nginx.service" ];
  };
}
```

### Handle Upstream TLS {#module-services-mitmdump-usage-https}

Replace `http` with `https` in `upstreamHost` if the server expects an HTTPS connection:

```nix
{
  services.mitmdump.instances."https" = {
    listenPort = 8005;
    upstreamHost = "https://127.0.0.1";
    upstreamPort = 8000;
    after = [ "nginx.service" ];
  };
}
```

### Accept Connections from Anywhere {#module-services-mitmdump-usage-open}

By default, `mitmdump` is configured to only listen for connections from localhost.
Add `listenHost` to make `mitmdump` be more open:

```nix
{
  services.mitmdump.instances."open" = {
    listenHost = "0.0.0.0";
    listenPort = 8006;
    upstreamPort = 8000;
    after = [ "nginx.service" ];
  };
}
```

Of course this can expose the upstream service to the open internet,
great care should be taken when doing that.

## Addons {#module-services-mitmdump-addons}

All provided addons can be found under the `services.mitmproxy.addons` option.

To enable one for an instance, add it to its `enabledAddons` option. For example:

```nix
{
  services.mitmdump.instances."my-instance" = {
    enabledAddons = [ config.services.mitmdump.addons.logger ];
  };
}
```
