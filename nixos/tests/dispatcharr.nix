{ lib, pkgs, ... }:
{
  name = "dispatcharr";

  meta = {
    maintainers = with lib.maintainers; [ staticdev ];
  };

  nodes.machine =
    { ... }:
    {
      services.dispatcharr = {
        enable = true;
        secretKeyFile = pkgs.writeText "dispatcharr-secret-key" ''
          DJANGO_SECRET_KEY=django-test-secret-key-keep-it-long-and-random
        '';
        port = 8000;
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("dispatcharr.target")
    machine.wait_for_open_port(8000)
    machine.succeed("curl -sSf http://127.0.0.1:8000/ | grep -i dispatcharr")
  '';
}
