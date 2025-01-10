import ./make-test-python.nix ({ lib, pkgs, ... }: {

  name = "sing-box";

  meta = {
    maintainers = with lib.maintainers; [ nickcao ];
  };

  nodes.machine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.curl ];
    services.nginx = {
      enable = true;
      statusPage = true;
    };
    services.sing-box = {
      enable = true;
      settings = {
        inbounds = [{
          type = "mixed";
          tag = "inbound";
          listen = "127.0.0.1";
          listen_port = 1080;
          users = [{
            username = "user";
            password = { _secret = pkgs.writeText "password" "supersecret"; };
          }];
        }];
        outbounds = [{
          type = "direct";
          tag = "outbound";
        }];
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("nginx.service")
    machine.wait_for_unit("sing-box.service")

    machine.wait_for_open_port(80)
    machine.wait_for_open_port(1080)

    machine.succeed("curl --fail --max-time 10 --proxy http://user:supersecret@localhost:1080 http://localhost")
    machine.fail("curl --fail --max-time 10 --proxy http://user:supervillain@localhost:1080 http://localhost")
    machine.succeed("curl --fail --max-time 10 --proxy socks5://user:supersecret@localhost:1080 http://localhost")
  '';

})
