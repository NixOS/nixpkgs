{ pkgs, ... }:

{
  name = "remark42";

  nodes.machine =
    { ... }:
    {
      environment.systemPackages = [ pkgs.curl ];

      services.remark42 = {
        enable = true;
        remarkUrl = "http://127.0.0.1:8080";
        sites = [ "remark" ];

        environmentFile = pkgs.writeText "remark42.env" ''
          SECRET=unit-test-secret
        '';

        settings.AUTH_ANON = "true";
      };
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("remark42.service")
    machine.wait_for_open_port(8080)
    machine.succeed("curl -fsS http://127.0.0.1:8080/web/ | head")
  '';
}
