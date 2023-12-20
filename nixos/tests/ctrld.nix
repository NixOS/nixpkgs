
import ./make-test-python.nix ({ pkgs, ... }: {
  name = "ctrld";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ arthsmn ];
  };

  nodes = {
    client = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.dig ];
      services.ctrld = {
        enable = true;
        settings = {
          listener."listener.0" = {
            ip = "";
            port = 0;
            restricted = false;
          };

          network."network.0" = {
            cidrs = [ "0.0.0.0/0" ];
            name = "Network 0";
          };

          service = {
            log_level = "info";
            log_path = "";
          };

          upstream = {
            "upstream.0" = {
              bootstrap_ip = "76.76.2.11";
              endpoint = "https://freedns.controld.com/p1";
              name = "Control D - Anti-Malware";
              timeout = 5000;
              type = "doh";
            };

            "upstream.1" = {
              bootstrap_ip = "76.76.2.11";
              endpoint = "p2.freedns.controld.com";
              name = "Control D - No Ads";
              timeout = 3000;
              type = "doq";
            };
          };
        };
      };
    };
  };

  # https://github.com/Control-D-Inc/ctrld#basic-run-mode
  testScript = ''
    client.wait_for_unit("ctrld")
    client.wait_until_succeeds("dig verify.controld.com @127.0.0.1 +short")
  '';
})
