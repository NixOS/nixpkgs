{ lib, ... }:
{
  name = "PDS";

  nodes.machine = {
    services.bluesky-pds = {
      enable = true;
      settings = {
        PDS_PORT = 3000;
        PDS_HOSTNAME = "example.com";

        # Snake oil testing credentials
        PDS_JWT_SECRET = "7b93fee53be046bf59c27a32a0fb2069";
        PDS_ADMIN_PASSWORD = "3a4077bc0d5f04eca945ef0509f7e809";
        PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX = "ae4f5028d04c833ba630f29debd5ff80b7700e43e9f4bf70f729a88cd6a6ce35";
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("bluesky-pds.service")
    machine.wait_for_open_port(3000)
    machine.succeed("curl --fail http://localhost:3000")
  '';

  meta.maintainers = with lib.maintainers; [ t4ccer ];
}
