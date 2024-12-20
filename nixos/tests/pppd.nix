import ./make-test-python.nix (
  let
    chap-secrets = {
      text = ''"flynn" * "reindeerflotilla" *'';
      mode = "0640";
    };
  in
  {
    name = "pppd";

    nodes = {
      server =
        { config, pkgs, ... }:
        {
          config = {
            # Run a PPPoE access concentrator server. It will spawn an
            # appropriate PPP server process when a PPPoE client sets up a
            # PPPoE session.
            systemd.services.pppoe-server = {
              restartTriggers = [
                config.environment.etc."ppp/pppoe-server-options".source
                config.environment.etc."ppp/chap-secrets".source
              ];
              after = [ "network.target" ];
              serviceConfig = {
                ExecStart = "${pkgs.rpPPPoE}/sbin/pppoe-server -F -O /etc/ppp/pppoe-server-options -q ${pkgs.ppp}/sbin/pppd -I eth1 -L 192.0.2.1 -R 192.0.2.2";
              };
              wantedBy = [ "multi-user.target" ];
            };
            environment.etc = {
              "ppp/pppoe-server-options".text = ''
                lcp-echo-interval 10
                lcp-echo-failure 2
                plugin pppoe.so
                require-chap
                nobsdcomp
                noccp
                novj
              '';
              "ppp/chap-secrets" = chap-secrets;
            };
          };
        };
      client =
        { config, pkgs, ... }:
        {
          services.pppd = {
            enable = true;
            peers.test = {
              config = ''
                plugin pppoe.so eth1
                name "flynn"
                noipdefault
                persist
                noauth
                debug
              '';
            };
          };
          environment.etc."ppp/chap-secrets" = chap-secrets;
        };
    };

    testScript = ''
      start_all()
      client.wait_until_succeeds("ping -c1 -W1 192.0.2.1")
      server.wait_until_succeeds("ping -c1 -W1 192.0.2.2")
    '';
  }
)
