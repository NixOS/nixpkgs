{ pkgs, ... }:
{
  name = "nemorosa";

  meta = with pkgs.lib.maintainers; {
    maintainers = [
      undefined-landmark
    ];
  };

  nodes.machine = {
    services.qbittorrent = {
      enable = true;
      # nemorosa expects the client to have > 0 torrents
      extraArgs = [
        "magnet:?xt=urn:btih:d4487f489d4ee786f99bcdeeb8d3f226694ea27f&dn=archlinux-2025.11.01-x86_64.iso"
      ];
      serverConfig.Preferences.WebUI = {
        Username = "user";
        # password: "adminadmin" as ByteArray
        Password_PBKDF2 = "@ByteArray(6DIf26VOpTCYbgNiO6DAFQ==:e6241eaAWGzRotQZvVA5/up9fj5wwSAThLgXI2lVMsYTu1StUgX9MgmElU3Sa/M8fs+zqwZv9URiUOObjqJGNw==)";
      };
    };

    services.nemorosa = {
      enable = true;
      settings = {
        downloader.client = "qbittorrent+http://user:adminadmin@localhost:8080/";
        server.port = 8266;
      };
    };
  };

  testScript = # python
    ''
      machine.start()
      # Nemorosa initialization expects an available API connection. So the
      # service will not start successfully. Do some basic checks on the
      # console as an alternative.
      machine.wait_for_console_text("Starting Nemorosa web server on localhost:8266")
      machine.wait_for_console_text("Rebuilt cache with 1 torrents from new client")
    '';
}
