# qBittorrent-nox {#module-services-torrent-qbittorrent-nox}

qBittorrent-nox is available as a standalone package as `qbittorrent-nox`, it can be installed to test the program before setting up the service.

Options can be decleared like the following. On first start up check the logs with `journelctl -u qbittorrent-nox`, You'll need the temporary password to login to the webui as the admin account, Then you can go to the gear icon -> `Web UI` -> `Authentication` and change the password. [You can connect to the webui at port 8080 as shown in the example below.](http://localhost:8080/)
```nix
services.qbittorrent-nox = {
  enable = true;

  port = 8080;
  openFirewall = true;
};
```
[More options are listed here.](https://search.nixos.org/options?query=services.qbittorrent) Lastly, watch out for permissions problems with other programs that either read/write from the downloads folder.
