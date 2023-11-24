import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "frp";
  meta.maintainers = with lib.maintainers; [ zaldnoay janik ];
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

      services.frp = {
        enable = true;
        role = "server";
        settings = {
          common = {
            bind_port = 7000;
            vhost_http_port = 80;
          };
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
        phpPackage = pkgs.php81;
        enablePHP = true;
      };

      services.frp = {
        enable = true;
        role = "client";
        settings = {
          common = {
            server_addr = "10.0.0.1";
            server_port = 7000;
          };
          web = {
            type = "http";
            local_port = 80;
            custom_domains = "10.0.0.1";
          };
        };
      };
    };
  };

  testScript = ''
    start_all()
    frps.wait_for_unit("frp.service")
    frps.wait_for_open_port(80)
    frpc.wait_for_unit("frp.service")
    response = frpc.succeed("curl -fvvv -s http://127.0.0.1/")
    assert "PHP Version ${pkgs.php81.version}" in response, "PHP version not detected"
    response = frpc.succeed("curl -fvvv -s http://10.0.0.1/")
    assert "PHP Version ${pkgs.php81.version}" in response, "PHP version not detected"
  '';
})
