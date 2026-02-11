{ pkgs, ... }:
{
  name = "coredns";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ johanot ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.dnsutils ];
      services.coredns = {
        enable = true;
        config = ''
          .:10053 {
                ipecho {
                  domain test.nixos.org
                  ttl 2629800
                }
              }
        '';
        package = pkgs.coredns.override {
          externalPlugins = [
            {
              name = "ipecho";
              repo = "github.com/Eun/coredns-ipecho";
              version = "224170ebca45cc59c6b071d280a18f42d1ff130c";
              position = "start-of-file";
            }
          ];
          vendorHash = "sha256-dNxHpXkiqz7B/JhZdxfZluIHFVXILlSm3XtB+v/EoMY=";
        };
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("coredns.service")
    machine.wait_for_open_port(10053)
    machine.succeed("dig @127.0.0.1 -p 10053 127.0.0.2.test.nixos.org A +short | grep 127.0.0.2")
  '';
}
