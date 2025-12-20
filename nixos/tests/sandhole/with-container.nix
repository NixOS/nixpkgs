{ pkgs, ... }:

let
  inherit (import ../ssh-keys.nix pkgs)
    snakeOilEd25519PrivateKey
    snakeOilEd25519PublicKey
    ;

  pubKey = pkgs.writeTextDir "user_keys/snakeoil.pub" snakeOilEd25519PublicKey;

in

{
  name = "sandhole-with-container";
  meta.maintainers = with pkgs.lib.maintainers; [ EpicEric ];

  nodes.machine =
    { ... }:
    {
      virtualisation.vlans = [ 10 ];
      networking = {
        nameservers = [
          "8.8.8.8"
          "8.8.4.4"
        ];
      };
      services.sandhole = {
        enable = true;
        openFirewall = true;
        settings = {
          domain = "sandhole.nix";
          userKeysDirectory = "${pubKey}/user_keys";
          bindHostnames = "all";
          disableHttps = true;
          httpPort = 8080;
        };
      };

      containers.httpd = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "172.16.0.1";
        localAddress = "172.16.0.2";
        config = {
          services.httpd = {
            enable = true;
            adminAddr = "foo@example.org";
          };
          networking.firewall.allowedTCPPorts = [ 80 ];
          system.stateVersion = "25.11";
        };
      };
      users.users.autossh = {
        isNormalUser = true;
      };
      users.groups.autossh = { };
      services.autossh.sessions = [
        {
          name = "httpd";
          user = "autossh";
          extraArguments = ''
            -i ${snakeOilEd25519PrivateKey} \
            -o StrictHostKeyChecking=accept-new \
            -o ServerAliveInterval=30 \
            -R httpd.sandhole.nix:80:172.16.0.2:80 \
            -p 2222 \
            127.0.0.1
          '';
        }
      ];
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("sandhole.service")
    machine.wait_for_open_port(2222)
    machine.wait_for_unit("autossh-httpd.service")
    machine.wait_for_unit("multi-user.target")
    machine.wait_until_succeeds(
      "${pkgs.curl}/bin/curl --fail"
      "  --resolve httpd.sandhole.nix:8080:127.0.0.1"
      "  http://httpd.sandhole.nix:8080"
      "  | grep 'It works!'",
      timeout=30,
    )
  '';
}
