{ pkgs, lib, ... }:
<<<<<<< HEAD
let
  token = "1234";
  dummyFile = pkgs.writeTextFile {
    name = "secrets";
    text = "dummy=value";
  };
  secretFile = pkgs.writeTextFile {
    name = "secrets";
    text = "token=${token}";
  };
in
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
{
  name = "frp";
  meta.maintainers = with lib.maintainers; [ zaldnoay ];
  nodes = {
    frps = {
      networking = {
        useNetworkd = true;
        useDHCP = false;
        firewall.enable = false;
      };

      systemd.network.networks."01-eth1" = {
        name = "eth1";
        networkConfig.Address = "10.0.0.1/24";
      };

<<<<<<< HEAD
      services.frp.instances.server = {
        enable = true;
        role = "server";
        environmentFiles = [
          (builtins.toPath dummyFile)
          (builtins.toPath secretFile)
        ];
        settings = {
          bindPort = 7000;
          vhostHTTPPort = 80;
          auth.method = "token";
          auth.token = "{{ .Envs.token }}";
=======
      services.frp = {
        enable = true;
        role = "server";
        settings = {
          bindPort = 7000;
          vhostHTTPPort = 80;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        };
      };
    };

    frpc = {
      networking = {
        useNetworkd = true;
        useDHCP = false;
      };

      systemd.network.networks."01-eth1" = {
        name = "eth1";
        networkConfig.Address = "10.0.0.2/24";
      };

      services.httpd = {
        enable = true;
        adminAddr = "admin@example.com";
        virtualHosts."test-appication" =
          let
            testdir = pkgs.writeTextDir "web/index.php" "<?php phpinfo();";
          in
          {
            documentRoot = "${testdir}/web";
            locations."/" = {
              index = "index.php index.html";
            };
          };
        phpPackage = pkgs.php84;
        enablePHP = true;
      };

<<<<<<< HEAD
      services.frp.instances.client = {
=======
      services.frp = {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        enable = true;
        role = "client";
        settings = {
          serverAddr = "10.0.0.1";
          serverPort = 7000;
<<<<<<< HEAD
          auth.method = "token";
          auth.token = token;
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
          proxies = [
            {
              name = "web";
              type = "http";
              localPort = 80;
              customDomains = [ "10.0.0.1" ];
            }
          ];
        };
      };
    };
  };

  testScript = ''
    start_all()
<<<<<<< HEAD
    frps.wait_for_unit("frp-server.service")
    frps.wait_for_open_port(80)
    frpc.wait_for_unit("frp-client.service")
=======
    frps.wait_for_unit("frp.service")
    frps.wait_for_open_port(80)
    frpc.wait_for_unit("frp.service")
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    response = frpc.succeed("curl -fvvv -s http://127.0.0.1/")
    assert "PHP Version ${pkgs.php84.version}" in response, "PHP version not detected"
    response = frpc.succeed("curl -fvvv -s http://10.0.0.1/")
    assert "PHP Version ${pkgs.php84.version}" in response, "PHP version not detected"
  '';
}
