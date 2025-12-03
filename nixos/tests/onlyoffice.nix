let
  port = 8000;
in
{
  name = "onlyoffice";

  nodes.machine =
    { pkgs, ... }:
    {
      services.onlyoffice = {
        enable = true;
        inherit port;
        hostname = "office.example.com";
        securityNonceFile = "${pkgs.writeText "nixos-test-onlyoffice-nonce.conf" ''
          set $secure_link_secret "nixostest";
        ''}";
      };

      networking.hosts = {
        "::1" = [ "office.example.com" ];
      };
    };

  testScript = ''
    machine.wait_for_unit("onlyoffice-docservice.service")
    machine.wait_for_unit("onlyoffice-converter.service")
    machine.wait_for_open_port(${builtins.toString port})
    machine.succeed("curl --fail http://office.example.com/healthcheck")
  '';
}
