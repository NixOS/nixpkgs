{ ... }:
{
  _class = "service";
  imports = [ ./default.nix ];
  config = {
    systemd.service = {
      description = "Handshake service for kernel TLS consumers";
      documentation = [ "man:tlshd(8)" ];
      unitConfig.DefaultDependencies = false;
      before = [ "remote-fs-pre.target" ];
      wantedBy = [ "remote-fs.target" ];
      serviceConfig = {
        Restart = "on-failure";
        DynamicUser = true;
        AmbientCapabilities = [ "CAP_NET_ADMIN" ];
        CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
      };
    };
  };
}
