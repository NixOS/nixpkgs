{ config, lib, pkgs, ... }: with lib;
let
  cfg = config.services.openiscsi;
in {
  options.services.openiscsi = with types; {
    enable = mkEnableOption "the openiscsi iscsi daemon";
    enableAutoLoginOut = mkEnableOption ''
      automatic login and logout of all automatic targets.
      You probably do not want this.
    '';
    discoverPortal = mkOption {
      type = nullOr str;
      default = null;
      description = "Portal to discover targets on";
    };
    name = mkOption {
      type = str;
      description = "Name of this iscsi initiator";
      example = "iqn.2020-08.org.linux-iscsi.initiatorhost:example";
    };
    package = mkOption {
      type = package;
      description = "openiscsi package to use";
      default = pkgs.openiscsi;
      defaultText = "pkgs.openiscsi";
    };

    extraConfig = mkOption {
      type = str;
      default = "";
      description = "Lines to append to default iscsid.conf";
    };
  };

  config = mkIf cfg.enable {
    environment.etc."iscsi/iscsid.conf".text = ''
      ${readFile "${cfg.package}/etc/iscsi/iscsid.conf"}
      ${cfg.extraConfig}
      ${optionalString cfg.enableAutoLoginOut "node.startup = automatic"}
    '';
    environment.etc."iscsi/initiatorname.iscsi".text = "InitiatorName=${cfg.name}";

    systemd.packages = [ cfg.package ];

    systemd.services."iscsid".wantedBy = [ "multi-user.target" ];
    systemd.sockets."iscsid".wantedBy = [ "sockets.target" ];

    systemd.services."iscsi" = mkIf cfg.enableAutoLoginOut {
      wantedBy = [ "remote-fs.target" ];
      serviceConfig.ExecStartPre = mkIf (cfg.discoverPortal != null) "${cfg.package}/bin/iscsiadm --mode discoverydb --type sendtargets --portal ${cfg.discoverPortal} --discover";
    };

    environment.systemPackages = [ cfg.package ];
    boot.kernelModules = [ "iscsi_tcp" ]; # TODO
  };
}
