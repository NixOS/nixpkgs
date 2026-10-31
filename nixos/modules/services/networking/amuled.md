# aMule {#module-services-amule}

[aMule](https://www.amule.org/) is a free and open-source peer-to-peer file sharing client that supports the eD2k and Kad networks.
It allows users to search for, download, and share files with others on these networks.
The `amuled` daemon is the command-line version of aMule, designed to run as a background service without a graphical user interface, making it suitable for servers or headless systems.
It handles finding sources, managing download and upload queues, and interacting with the eD2k servers and Kad network.

Here an example which also enables amuleapi (the REST API and Web UI) and sets custom paths for the downloads:

```nix
{
  services.amule = {
    enable = true;
    openPeerPorts = true;
    ExternalConnectPasswordFile = "/run/secrets/amule-password";
    AmuleApiAdminPasswordFile = "/run/secrets/amule-api-password";
    settings = {
      eMule = {
        IncomingDir = "/mnt/hd/amule";
        TempDir = "/mnt/hd/amule/Temp";
      };
      AmuleApi.Enabled = 1;
    };
  };
}
```

You can connect using `amulegui` and choosing the host, port (`4712` by default) and password, the username is always `amule`.
Otherwise, if you enabled amuleapi, connect using the browser (port `4713` by default) and log in with the admin password.

Make `AmuleApiAdminPasswordFile` readable by the service user; a missing or unreadable file prevents startup.
amuleapi uses the EC port configured in `settings.ExternalConnect.ECPort`.

amuleapi listens on `127.0.0.1` by default, the upstream recommendation is to keep it there and put a reverse proxy in front of it.
To listen on another address set `settings.AmuleApi.BindAddress`, this requires an admin password, and `openAmuleApiPort` to open the port in the firewall.

The legacy web server, `amuleweb`, is deprecated upstream in favour of amuleapi but can still be enabled with `settings.WebServer.Enabled = 1` (port `4711` by default).
