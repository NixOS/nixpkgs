{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.mptcpd;
  settingsFormat = pkgs.formats.ini { };
in
{

  options = {

    services.mptcpd = {

      enable = lib.mkEnableOption "the Multipath TCP path management daemon";

      package = lib.mkPackageOption pkgs "mptcpd" { };

      settings = lib.mkOption {
        type = settingsFormat.type;
        default = { };
        example = lib.literalExpression ''
          {
            core = {
              "addr-flags" = "subflow";
              "notify-flags" = "existing,skip_link_local,skip_loopback,check_route";
              "load-plugins" = "addr_adv,sspi";
            };
          }
        '';
        description = ''
          mptcpd configuration written to {file}`/etc/mptcpd/mptcpd.conf`.

          See {manpage}`mptcpd(8)` for details about available options and syntax.
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

    environment.etc."mptcpd/mptcpd.conf".source = settingsFormat.generate "mptcpd.conf" cfg.settings;

    environment.systemPackages = [ cfg.package ];

    services.mptcpd.settings = {
      core = {
        log = lib.mkDefault "journal";
        "plugin-dir" = "${cfg.package}/lib/mptcpd";
        "path-manager" = lib.mkDefault "addr_adv";
      };
    };

    systemd.packages = [ cfg.package ];
    systemd.services.mptcp = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = [
        ""
        "${cfg.package}/libexec/mptcpd"
      ];
    };

  };

  meta.maintainers = with lib.maintainers; [ nim65s ];
}
