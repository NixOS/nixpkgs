import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "containers-after";
  meta = {
    maintainers = with lib.maintainers; [ thesola10 ];
  };

  machine =
    { lib, ... }:
    {
      virtualisation.vlans = [];

      systemd.tmpfiles.rules = [
        "d /run/dest 1777 root root -"
      ];

      networking.bridges.br0.interfaces = [];
      networking.interfaces.br0.ipv4.addresses = [
        { address = "10.10.0.254"; prefixLength = 24; }
      ];

      containers.before = {
        autoStart = true;
        privateNetwork = true;
        localAddress = "10.10.0.1/24";
        hostBridge = "br0";

        config = { lib, ... }:
        {
          networking.firewall.extraCommands = ''
            iptables -A INPUT -s 10.10.0.0/24 -j ACCEPT
          '';
          services.darkhttpd = {
            enable = true;
            address = "10.10.0.1";
            rootDir = ./common/webroot;
          };
        };
      };

      containers.after = {
        autoStart = true;
        privateNetwork = true;
        startAfter = [ "container@before.service" ];
        localAddress = "10.10.0.2/24";
        hostBridge = "br0";
        bindMounts."/dest" = {
          hostPath = "/run/dest";
          isReadOnly = false;
        };

        config = { lib, ... }:
        {
          networking.firewall.extraCommands = ''
            iptables -A INPUT -s 10.10.0.0/24 -j ACCEPT
          '';
          systemd.services."fetchBefore" =
            { path = with pkgs; [ wget ];
              wantedBy = [ "default.target" ];
              enable = true;
              serviceConfig =
              { ExecStart = pkgs.writeShellScript "run.sh" ''
                  wget http://10.10.0.1/news-rss.xml -O /dest/news-rss.xml
                '';
                Restart = "no";
                Type = "oneshot";
              };
            };
        };
      };
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("default.target")

    with subtest("Check if containers were started in the correct order"):
        machine.succeed("diff ${./common/webroot/news-rss.xml} /run/dest/news-rss.xml")
  '';
})
