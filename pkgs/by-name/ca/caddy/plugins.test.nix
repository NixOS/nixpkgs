{ lib, ... }:

{
  name = "caddy-plugins";
  meta.maintainers = with lib.maintainers; [
    stepbrobd
  ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.caddy = {
        enable = true;

        package = pkgs.caddy.withPlugins {
          plugins = [ "github.com/caddyserver/replace-response@v0.0.0-20250618171559-80962887e4c6" ];
          hash = "sha256-oj0IpspxslpNZbJFsexh0W2Sja19XRUsbShoCuY6qkQ=";
        };

        globalConfig = ''
          order replace after encode
        '';

        virtualHosts."localhost:80".extraConfig = ''
          respond "hello world"
          replace world nixos
        '';
      };
    };

  testScript = ''
    machine.wait_for_unit("caddy")
    machine.wait_for_open_port(80)
    machine.succeed("curl http://localhost | grep nixos")
  '';
}
