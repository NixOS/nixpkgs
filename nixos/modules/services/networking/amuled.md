# aMule {#module-services-amule}

[aMule](https://www.amule.org/) is a free and open-source peer-to-peer file sharing client that supports the eD2k and Kad networks.
It allows users to search for, download, and share files with others on these networks.
The `amuled` daemon is the command-line version of aMule, designed to run as a background service without a graphical user interface, making it suitable for servers or headless systems.
It handles finding sources, managing download and upload queues, and interacting with the eD2k servers and Kad network.

Here an example which also enables the web server and sets custom paths for the downloads:

```nix
{
  services.amule = {
    enable = true;
    openPeerPorts = true;
    openWebServerPort = true;
    ExternalConnectPasswordFile = "/run/secrets/amule-password";
    WebServerPasswordFile = "/run/secrets/amule-web/password";
    settings = {
      eMule = {
        IncomingDir = "/mnt/hd/amule";
        TempDir = "/mnt/hd/amule/Temp";
      };
      WebServer.Enabled = 1;
    };
  };
}
```

You can connect using `amulegui` and choosing the host, port (`4712` by default) and password, the username is always `amule`.
Otherwise, if you enabled the web server, connect using the browser (port `4711` by default).
