{ lib, pkgs, ... }:

{
  systemd.services.go-sendxmpp-listen = {
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        ${lib.getExe pkgs.go-sendxmpp} --username azurediamond@example.com --password hunter2 --listen
      '';
      Environment = [
        "HOME=/var/lib/go-sendxmpp/"
      ];
      DynamicUser = true;
      Restart = "on-failure";
      RestartSec = "5s";
      StateDirectory = "go-sendxmpp";
    };
  };
}
