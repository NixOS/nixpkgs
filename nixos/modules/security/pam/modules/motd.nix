{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "motd";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      default = if global then false else modCfg.enable;
      type = types.bool;
      description = "Whether to show the message of the day.";
    };

    motdFile = mkOption {
      type = types.path;
      default = if global then (pkgs.writeText "motd" config.users.motd) else modCfg.motdFile;
      description = "The path to the motd file.";
    };
  };

  mkSessionConfig = svcCfg: {
    ${name} = {
      control = "optional";
      path = "${pkgs.pam}/lib/security/pam_motd.so";
      args = [ "motd=${svcCfg.modules.${name}.motdFile}" ];
      order = 14000;
    };
  };

in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      inherit name mkModuleOptions mkSessionConfig;
      mkSvcConfigCondition = svcCfg: svcCfg.modules.${name}.enable && (config.users.motd != null);
    };

    users.motd = mkOption {
      default = null;
      type = types.nullOr types.lines;
      description = "Message of the day shown to users when they log in.";
      example = "Today is Sweetmorn, the 4th day of The Aftermath in the YOLD 3178.";
    };
  };
}
