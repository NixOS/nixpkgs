# c2FmZQ {#module-services-c2fmzq}

c2FmZQ is an application that can securely encrypt, store, and share files,
including but not limited to pictures and videos.

The service `c2fmzq-server` can be enabled by setting
```
{
  services.c2fmzq-server.enable = true;
}
```
This will spin up an instance of the server which is API-compatible with
[Stingle Photos](https://stingle.org) and an experimental Progressive Web App
(PWA) to interact with the storage via the browser.

In principle the server can be exposed directly on a public interface and there
are command line options to manage HTTPS certificates directly, but the module
is designed to be served behind a reverse proxy or only accessed via localhost.

```
{
  services.c2fmzq-server = {
    enable = true;
    bindIP = "127.0.0.1"; # default
    port = 8080; # default
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."example.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
      };
    };
  };
}
```

For more information, see <https://github.com/c2FmZQ/c2FmZQ/>.
