# Mitmdump {#module-services-mitmdump}

[mitmproxy][] is a set of tools that provide an interactive, SSL/TLS-capable intercepting proxy for HTTP/1, HTTP/2, and WebSockets.
[mitmdump][] is the command-line non-interactive version of mitmproxy.

This module sets up one or multiple instances of mitmdump in [reverse proxy][] mode
which allows to intercept network graphic and dump the HTTP requests and responses.
It is particularly useful to debug interaction between two services.

[mitmproxy]: https://docs.mitmproxy.org/stable
[mitmdump]: https://plattner.me/mp-docs/#mitmdump
[reverse proxy]: https://plattner.me/mp-docs/concepts-modes/#reverse-proxy

Each `mitmdump` instance has its own systemd service which is only considered started
when the mitmdump instance has started listening on the expected port.

Also, addons can be enabled with the `enabledAddons` option.

## Getting Started {#module-services-mitmdump-getting-started}

Let's assume a server is listening on port 8000
which responds a plain text response `test1`
and its related systemd service is named `test1.service`.
Sorry, creative naming is not my forte.

Let's put an mitmdump instance in front of it, like so:

```nix
{
  services.mitmdump.instances."test1" = {
    listenPort = 8001;
    upstreamPort = 8000;
    after = [ "test1.service" ];
    extraArgs = [
      "--set"
      "flow_detail=3"
      "--set"
      "content_view_lines_cutoff=2000"
    ];
  };
}
```

This creates an `mitmdump-test1.service` systemd service.
We can then use `journalctl -u mitmdump-test1.service` to see the output.

If we make a `curl` request to it: `curl -v http://127.0.0.1:8001`,
we will get the following output:

```
mitmdump-test1[971]: 127.0.0.1:40878: GET http://127.0.0.1:8000/ HTTP/1.1
mitmdump-test1[971]:     Host: 127.0.0.1:8000
mitmdump-test1[971]:     User-Agent: curl/8.14.1
mitmdump-test1[971]:     Accept: */*
mitmdump-test1[971]:  << HTTP/1.0 200 OK 5b
mitmdump-test1[971]:     Server: BaseHTTP/0.6 Python/3.13.4
mitmdump-test1[971]:     Date: Thu, 31 Jul 2025 20:55:16 GMT
mitmdump-test1[971]:     Content-Type: text/plain
mitmdump-test1[971]:     Content-Length: 5
mitmdump-test1[971]:     test1
```

## Usage {#module-services-mitmdump-usage}

Put mitmdump in front of a HTTP server listening on port 8000 on the same machine:

```nix
{
  services.mitmdump.instances."my-instance" = {
    listenPort = 8001;
    upstreamHost = "http://127.0.0.1";
    upstreamPort = 8000;
    after = [ "server.service" ];
  };
}
```

`upstreamHost` has its default value here and can be left out.

Put mitmdump in front of a HTTP server listening on port 8000 on another machine:

```nix
{
  services.mitmdump.instances."my-instance" = {
    listenPort = 8001;
    upstreamHost = "http://otherhost";
    upstreamPort = 8000;
    after = [ "server.service" ];
  };
}
```

### Handle Upstream TLS {#module-services-mitmdump-usage-https}

Replace `http` with `https` in `upstreamHost` if the server expects an HTTPS connection.

### Accept Connections from Anywhere {#module-services-mitmdump-usage-anywhere}

By default, `mitmdump` is configured to only listen for connections from localhost.
Add `listenHost` to make `mitmdump` be more open:

```nix
{
  services.mitmdump.instances."my-instance" = {
    listenHost = "0.0.0.0";
    listenPort = 8001;
    upstreamHost = "http://otherhost";
    upstreamPort = 8000;
    after = [ "server.service" ];
  };
}
```

Of course this can expose the upstream service to the open internet,
great care should be taken when doing that.

### Extra Logging {#module-services-mitmdump-usage-logging}

To print request and response bodies and headers, increase the logging with `extraArgs`:

```nix
{
  services.mitmdump.instances."my-instance" = {
    extraArgs = [
      "--set"
      "flow_detail=3"
      "--set"
      "content_view_lines_cutoff=2000"
    ];
  };
}
```

The default `flow_details` is 1. See the [mitmdump manual][] for more explanations on the option.

[manual]: (https://docs.mitmproxy.org/stable/concepts/options/#flow_detail)

This will change the verbosity for all requests and responses.
If you need more fine grained logging, configure instead the [Logger Addon][].

[Logger Addon]: #module-services-mitmdump-addons-logger

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

### Fine Grained Logger {#module-services-mitmdump-addons-logger}

The Fine Grained Logger addon is found under `services.mitmproxy.addons.logger`.
Enabling this addon will add the `mitmdump` option `verbose_pattern` which takes a regex and if it matches,
prints the request and response headers and body.
If it does not match, it will just print the response status.

For example, with the `extraArgs`:

```nix
{
  services.mitmdump.instances."test1".extraArgs = [
    "--set"
    "verbose_pattern=/verbose"
  ];
}
```

A `GET` request to `/notverbose` will print something similar to:

```
mitmdump[972]: 127.0.0.1:53586: GET http://127.0.0.1:8000/notverbose HTTP/1.1
mitmdump[972]:      << HTTP/1.0 200 OK 16b
```

While a `GET` request to `/verbose` will print something similar to:

```
mitmdump[972]: [22:42:58.840]
mitmdump[972]: RequestHeaders:
mitmdump[972]:     Host: 127.0.0.1:8000
mitmdump[972]:     User-Agent: curl/8.14.1
mitmdump[972]:     Accept: */*
mitmdump[972]: RequestBody:
mitmdump[972]: Status:          200
mitmdump[972]: ResponseHeaders:
mitmdump[972]:     Server: BaseHTTP/0.6 Python/3.13.4
mitmdump[972]:     Date: Sun, 03 Aug 2025 22:42:58 GMT
mitmdump[972]:     Content-Type: text/plain
mitmdump[972]:     Content-Length: 13
mitmdump[972]: ResponseBody:    test2/verbose
mitmdump[972]: 127.0.0.1:53602: GET http://127.0.0.1:8000/verbose HTTP/1.1
mitmdump[972]:      << HTTP/1.0 200 OK 13b
```
