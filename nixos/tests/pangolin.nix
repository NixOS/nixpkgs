{ lib, ... }:
{
  name = "pangolin";
  meta.maintainers = with lib.maintainers; [ jackr ];

  nodes.machine = {
    environment.etc."nixos/secrets/pangolin.env".text = ''
      USERS_SERVERADMIN_PASSWORD=Password123!
    '';
    services.pangolin = {
      enable = true;
      baseDomain = "example.test";
      letsEncryptEmail = "email@example.test";
      openFirewall = true;
      pangolinEnvironmentFile = "/etc/nixos/secrets/pangolin.env";
    };
  };
  # Traefik will throw an error after startup:
  # ERR Unable to obtain ACME certificate for domains error ..
  # since nixos.org does not have the correct DNS record.
  # This test will be expanded in te future to be more
  # comprehensive and work with services.Newt
  testScript = ''
    machine.wait_for_unit("pangolin.service")
    for port in [80, 443, 51820]:
      machine.wait_for_open_port(port)
    for port in range(3000, 3002):
      machine.succeed(f"curl --fail http://localhost:{port}/")
  '';
}
