{ pkgs, ... }:
{
  name = "nemorosa";

  meta = with pkgs.lib.maintainers; {
    maintainers = [
      undefined-landmark
    ];
  };

  nodes = {
    declarative = {
      services.qbittorrent = {
        enable = true;
        serverConfig.Preferences.WebUI = {
          Username = "user";
          # password: "adminadmin" as ByteArray
          Password_PBKDF2 = "@ByteArray(6DIf26VOpTCYbgNiO6DAFQ==:e6241eaAWGzRotQZvVA5/up9fj5wwSAThLgXI2lVMsYTu1StUgX9MgmElU3Sa/M8fs+zqwZv9URiUOObjqJGNw==)";
        };
      };

      services.nemorosa = {
        enable = true;
        settings = {
          downloader.client = ''
            qbittorrent+http://user:adminadmin@localhost:8080/
          '';
        };
      };
    };
  };

  testScript = # python
    ''
      declarative.start(allow_reboot=True)

      declarative.wait_for_unit("qbittorrent.service")
      declarative.wait_for_open_port(8080)

      declarative.wait_for_unit("nemorosa.service")
      declarative.wait_for_open_port(8256)
      #with subtest("systemd service starts"):
    '';
}
