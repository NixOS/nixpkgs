{ lib, ... }:

{
  name = "kener";
  meta.maintainers = with lib.maintainers; [ albertlarsan68 ];

  containers.machine =
    { pkgs, ... }:
    {
      services.kener = {
        enable = true;
        environmentFile = pkgs.writeText "kener-env" ''
          KENER_SECRET_KEY=kener_secret_key_do_not_use
        '';
        settings = {
          ORIGIN = "http://localhost:3001";
        };
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("kener.service")
    machine.wait_for_open_port(3001)
    machine.wait_until_succeeds("curl --fail http://localhost:3001/healthcheck?strict=1")
  '';
}
