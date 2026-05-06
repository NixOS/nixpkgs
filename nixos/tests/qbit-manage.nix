{ pkgs, lib, ... }:
let
  webUIPort = 8888;
in
{
  name = "qbit-manage";

  meta = with pkgs.lib.maintainers; {
    maintainers = [
      flyingpeakock
    ];
  };

  nodes =
    let
      qbittorrent_port = 8181;
      qbittorrent_user = "user";
      environmentFile = pkgs.writeText "qbit-manage.env" ''
        QBIT_PASS="adminadmin"
      '';
      qbittorrent = {
        enable = true;
        webuiPort = null;
        serverConfig.Preferences.WebUI = {
          Username = qbittorrent_user;
          # Default password: adminadmin
          Password_PBKDF2 = "@ByteArray(6DIf26VOpTCYbgNiO6DAFQ==:e6241eaAWGzRotQZvVA5/up9fj5wwSAThLgXI2lVMsYTu1StUgX9MgmElU3Sa/M8fs+zqwZv9URiUOObjqJGNw==)";
          Port = qbittorrent_port;
        };
      };
    in
    {
      simple = {
        services = {
          qbit-manage = {
            enable = true;
          };
        };
      };

      declarative = {
        services = {
          inherit qbittorrent;
          qbit-manage = {
            enable = true;
            inherit environmentFile;

            config = {
              qbt = {
                host = "localhost:${toString qbittorrent_port}";
                user = qbittorrent_user;
                pass = "!ENV QBIT_PASS";
              };
              tracker = {
                dummy.tag = "dummy";
              };
              cat.dummy = "/tmp";
              directory.root_dir = "/tmp";
            };

            webServer = {
              enable = true;
              port = webUIPort;
            };

            commands.startupDelay = 5; # Allow time for qBittorrent to start
          };
        };
      };
    };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      def checkConfigExists(machine):
          machine.wait_for_unit("qbit-manage.service")
          machine.wait_for_file("/var/lib/qbit-manage/config.yml")

      with subtest("Check that config is created or copied when configured"):
          checkConfigExists(simple)
          checkConfigExists(declarative)

      with subtest("Check that qbit-manage connects to qBittorrent"):
          declarative.wait_for_console_text("Qbt Connection Successful")

      with subtest("Check that web server is running when enabled"):
          declarative.wait_for_open_port(${toString webUIPort})
    '';
}
