{ lib, ... }:

{
  name = "fider-server";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.fider = {
          enable = true;
          environment = {
            JWT_SECRET = "not_so_secret";
            BASE_URL = "/";
            EMAIL_NOREPLY = "noreply@fider.io";
            EMAIL_SMTP_HOST = "mailhog";
            EMAIL_SMTP_PORT = "1025";
          };
        };
      };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("fider.service")
    machine.wait_for_open_port(3000)
  '';

  meta.maintainers = with lib.maintainers; [
    niklaskorz
  ];
}
