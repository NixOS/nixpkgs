{ ... }:
{
  _class = "service";
  imports = [ ./default.nix ];
  config = {
    systemd.service = {
      after = [ "network.target" ];
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-failure";
        DynamicUser = true;
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      };
    };
  };
}
