{
  config,
  lib,
  pkg,
  ...
}:
let
  cfg = config.virtualisation.podman.networkSocket;

in
{
  options.virtualisation.podman.networkSocket = {
    server = lib.mkOption {
      type = lib.types.enum [ "ghostunnel" ];
    };
  };

  config = lib.mkIf (cfg.enable && cfg.server == "ghostunnel") {

    services.ghostunnel = {
      enable = true;
      servers."podman-socket" = {
        inherit (cfg.tls) cert key cacert;
        listen = "${cfg.listenAddress}:${toString cfg.port}";
        target = "unix:/run/podman/podman.sock";
        allowAll = lib.mkDefault true;
      };
    };
    systemd.services.ghostunnel-server-podman-socket.serviceConfig.SupplementaryGroups = [ "podman" ];

  };

  meta.maintainers = lib.teams.podman.members ++ [ lib.maintainers.roberth ];
}
