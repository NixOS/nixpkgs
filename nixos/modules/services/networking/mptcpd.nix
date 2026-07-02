{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let

  cfg = config.services.mptcpd;

in

{

  options = {

    services.mptcpd = {

      enable = lib.mkEnableOption "the Multipath TCP path management daemon";

      package = lib.mkPackageOption pkgs "mptcpd" { };

      extraMptcpdFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "--addr-flags=subflow"
          "--notify-flags=existing,skip_link_local,skip_loopback,check_route"
        ];
        description = ''
          Additional flags to pass to mptcpd commands. See "man 8 mptcpd" for more information.
        '';
      };

    };

  };

  config = lib.mkIf cfg.enable {

    # Disable NetworkManager from configuring the MPTCP endpoints.
    # See https://github.com/multipath-tcp/mptcpd/blob/48942b2110805af236ca41164fde67830efd7507/README.md?plain=1#L19-L38
    networking.networkmanager.connectionConfig = {
      "connection.mptcp-flags" = 1;
    };

    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.services.mptcp = {
      serviceConfig = {
        ExecStart = [
          "" # Resets command from upstream unit.
          (utils.escapeSystemdExecArgs (
            [
              "${cfg.package}/libexec/mptcpd"
              "--log=journal"
            ]
            ++ cfg.extraMptcpdFlags
          ))
        ];
      };
      wantedBy = [ "multi-user.target" ];
    };

  };

  meta.maintainers = with lib.maintainers; [ nim65s ];
}
