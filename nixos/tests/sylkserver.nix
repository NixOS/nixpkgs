{
  lib,
  ...
}:

let
  ports = {
    sip = 5060;
    xmpp = 5269;
    web = 10888;
  };
in

{
  name = "sylkserver";
  meta.maintainers = lib.teams.ngi.members;

  nodes.machine =
    { config, ... }:
    {
      services.sylkserver.enable = true;

      services.sylkserver.settings.config.SIP.local_tcp_port = ports.sip;
      services.sylkserver.settings.config.WebServer.public_port = ports.web;
      services.sylkserver.settings.xmppgateway.general.local_port = ports.xmpp;

      services.sylkserver.settings.config.SIP.local_ip = "0.0.0.0";
      services.sylkserver.settings.config.WebServer.hostname = "0.0.0.0";
      services.sylkserver.settings.xmppgateway.general.local_ip = "0.0.0.0";
    };

  testScript =
    { nodes, ... }:
    # python
    ''
      machine.start()
      machine.wait_for_unit("sylkserver.service")
      machine.wait_for_open_port(${toString ports.sip})

      machine.wait_for_console_text("Web server listening for requests")
      machine.succeed("""
        curl http://0.0.0.0:${toString ports.web} \
          --fail \
          --connect-timeout 2
      """)
    '';

  # for debugging
  interactive.sshBackdoor.enable = true;
  interactive.nodes = {
    machine =
      { pkgs, lib, ... }:
      {
        imports = [
          # enable graphical session + users (alice, bob)
          ./common/x11.nix
          ./common/user-account.nix
        ];

        # forward ports from VM to host
        virtualisation.forwardPorts = lib.mapAttrsToList (_: port: {
          from = "host";
          host = { inherit port; };
          guest = { inherit port; };
        }) ports;

        services.xserver.enable = true;
        test-support.displayManager.auto.user = "alice";

        networking.firewall.enable = false;

        # TODO: connect client to server
        environment.systemPackages = with pkgs; [
          sylk
          freetalk
          pidgin
        ];
      };
  };
}
