{
  config,
  pkgs,
  lib,
  utils,
  ...
}:

let
  cfg = config.services.atalkd;

  # Generate atalkd.conf only if configFile isn't manually specified
  atalkdConfFile = pkgs.writeText "atalkd.conf" (
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        iface: ifaceCfg: iface + (if ifaceCfg.config != null then " ${ifaceCfg.config}" else "")
      ) cfg.interfaces
    )
  );
in
{
  options.services.atalkd = {
    enable = lib.mkEnableOption "the AppleTalk daemon";

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = atalkdConfFile;
      defaultText = "/nix/store/xxx-atalkd.conf";
      description = ''
        Optional path to a custom `atalkd.conf` file. When set, this overrides the generated
        configuration from `services.atalkd.interfaces`.
      '';
    };

    interfaces = lib.mkOption {
      description = "Per-interface configuration for atalkd.";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options.config = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Optional configuration string for this interface.";
          };
        }
      );
      default = { };
    };
  };

  config =
    let
      interfaces = map (iface: "sys-subsystem-net-devices-${utils.escapeSystemdPath iface}.device") (
        builtins.attrNames cfg.interfaces
      );
    in
    lib.mkIf cfg.enable {
      system.requiredKernelConfig = [
        (config.lib.kernelConfig.isEnabled "APPLETALK")
      ];
      systemd.services.netatalk.partOf = [ "atalkd.service" ];
      systemd.services.netatalk.after = interfaces;
      systemd.services.netatalk.requires = interfaces;
      systemd.services.atalkd =
        let
          interfaces = map (iface: "sys-subsystem-net-devices-${utils.escapeSystemdPath iface}.device") (
            builtins.attrNames cfg.interfaces
          );
        in
        {

          description = "atalkd AppleTalk daemon";
          unitConfig.Documentation = "man:atalkd.conf(5) man:atalkd(8)";
          after = interfaces;
          wants = [ "network.target" ];
          before = [ "netatalk.service" ];
          requires = interfaces;

          wantedBy = [ "multi-user.target" ];

          path = [ pkgs.netatalk ];

          serviceConfig = {
            Type = "forking";
            GuessMainPID = "no";
            DynamicUser = true;
            AmbientCapabilities = [ "CAP_NET_ADMIN" ];
            RuntimeDirectory = "atalkd";
            PIDFile = "/run/atalkd/atalkd";
            BindPaths = [ "/run/atalkd:/run/lock" ];
            ExecStart = "${pkgs.netatalk}/bin/atalkd -f ${cfg.configFile}";
            Restart = "always";
          };
        };
    };

  meta.maintainers = with lib.maintainers; [ matthewcroughan ];
  meta.doc = ./atalkd.md;
}
