{ pkgs, ... }:
{
  name = "agorakit";

  meta.maintainers = with pkgs.lib.maintainers; [ julienmalka ];

  nodes = {
    agorakit =
      { ... }:
      {
        services.agorakit = {
          enable = true;
          appKeyFile = toString (
            pkgs.writeText "agorakit-app-key" "uTqGUN5GUmUrh/zSAYmhyzRk62pnpXICyXv9eeITI8k="
          );
          hostName = "localhost";
          database.createLocally = true;
          mail = {
            driver = "smtp";
            encryption = "tls";
            host = "localhost";
            port = 1025;
            fromName = "Agorakit";
            from = "agorakit@localhost";
            user = "agorakit@localhost";
            passwordFile = toString (pkgs.writeText "agorakit-mail-pass" "a-secure-mail-password");
          };
        };
      };
  };

  testScript = ''
    start_all()

    agorakit.wait_for_unit("nginx.service")
    agorakit.wait_for_unit("agorakit-setup.service")

    # Login page should now contain the configured site name

    agorakit.succeed("curl http://localhost/login | grep Agorakit")

  '';
}
