{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.openiscsi;
in
{
  options.services.openiscsi = with lib.types; {
    enable = lib.mkEnableOption "the openiscsi iscsi daemon";
    enableAutoLoginOut = mkEnableOption ''
      automatic login and logout of all automatic targets.
      You probably do not want this
    '';
    discoverPortal = lib.mkOption {
      type = nullOr str;
      default = null;
      description = "Portal to discover targets on";
    };
    name = lib.mkOption {
      type = str;
      description = "Name of this iscsi initiator";
      example = "iqn.2020-08.org.linux-iscsi.initiatorhost:example";
    };
    package = lib.mkPackageOption pkgs "openiscsi" { };

    extraConfig = lib.mkOption {
      type = str;
      default = "";
      description = "Lines to append to default iscsid.conf";
    };

    extraConfigFile = lib.mkOption {
      description = ''
        Append an additional file's contents to /etc/iscsid.conf. Use a non-store path
        and store passwords in this file.
      '';
      default = null;
      type = nullOr str;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."iscsi/iscsid.conf.fragment".source = pkgs.runCommand "iscsid.conf" { } ''
      cat "${cfg.package}/etc/iscsi/iscsid.conf" > $out
      cat << 'EOF' >> $out
      ${cfg.extraConfig}
      ${lib.optionalString cfg.enableAutoLoginOut "node.startup = automatic"}
      EOF
    '';
    environment.etc."iscsi/initiatorname.iscsi".text = "InitiatorName=${cfg.name}";

    systemd.packages = [ cfg.package ];

    systemd.services."iscsid" = {
      wantedBy = [ "multi-user.target" ];
      preStart =
        let
          extraCfgDumper = lib.optionalString (cfg.extraConfigFile != null) ''
            if [ -f "${cfg.extraConfigFile}" ]; then
              printf "\n# The following is from ${cfg.extraConfigFile}:\n"
              cat "${cfg.extraConfigFile}"
            else
              echo "Warning: services.openiscsi.extraConfigFile ${cfg.extraConfigFile} does not exist!" >&2
            fi
          '';
        in
        ''
          (
            cat ${config.environment.etc."iscsi/iscsid.conf.fragment".source}
            ${extraCfgDumper}
          ) > /etc/iscsi/iscsid.conf
        '';
    };
    systemd.sockets."iscsid".wantedBy = [ "sockets.target" ];

    systemd.services."iscsi" = lib.mkIf cfg.enableAutoLoginOut {
      wantedBy = [ "remote-fs.target" ];
      serviceConfig.ExecStartPre =
        lib.mkIf (cfg.discoverPortal != null)
          "${cfg.package}/bin/iscsiadm --mode discoverydb --type sendtargets --portal ${lib.escapeShellArg cfg.discoverPortal} --discover";
    };

    environment.systemPackages = [ cfg.package ];
    boot.kernelModules = [ "iscsi_tcp" ];
  };
}
