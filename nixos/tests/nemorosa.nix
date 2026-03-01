{ lib, pkgs, ... }:
{
  name = "nemorosa";

  meta = with pkgs.lib.maintainers; {
    maintainers = [
      undefined-landmark
    ];
  };

  nodes.machine =
    let
      qbitUrl = "qbittorrent+http://user:adminadmin@localhost:8080/";
      # We create this secret in the Nix store (making it readable by everyone).
      # DO NOT DO THIS OUTSIDE OF TESTS!!
      testSecret = pkgs.writeText "qbitUrl" qbitUrl;
    in
    {
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
        settings.downloader.client = lib.mkDefault qbitUrl;
      };

      specialisation.secretSubstition.configuration = {
        services.nemorosa = {
          enable = true;
          settings = {
            downloader.client = {
              _secret = toString testSecret;
            };
            server.port = 8266;
          };
        };
      };
    };

  testScript =
    { nodes, ... }:
    let
      secretSubst = "${nodes.machine.system.build.toplevel}/specialisation/secretSubstition";
    in
    # python
    ''
      machine.start()

      # Nemorosa initialization expects an available API connection. So the
      # service will not start successfully. Do some basic checks on the
      # console log as an alternative.
      def test_log(port):
        machine.wait_for_console_text("Configuration loaded successfully from: /var/lib/nemorosa/config.yaml")
        machine.wait_for_console_text(f"Starting Nemorosa web server on 127.0.0.1:{port}")
        machine.wait_for_console_text("Successfully connected to torrent client")

      test_log(8256)

      machine.succeed("${secretSubst}/bin/switch-to-configuration test")
      test_log(8266)
    '';
}
