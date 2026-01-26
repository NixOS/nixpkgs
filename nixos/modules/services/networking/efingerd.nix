{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.efingerd;
in
{
  options.services.efingerd = {
    enable = mkEnableOption "efingerd finger daemon via xinetd";

    package = mkOption {
      type = types.package;
      default = pkgs.efingerd;
      defaultText = "pkgs.efingerd";
      description = "The efingerd package to use.";
    };

    user = mkOption {
      type = types.str;
      description = "User to run efingerd as (required).";
    };

    connectionTimeout = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 25;
      description = "Time in seconds to keep connection. If null, default behavior is used.";
    };

    noLookupAddresses = mkOption {
      type = types.bool;
      default = false;
      description = "Do not lookup addresses, use IP numbers instead.";
    };

    useIdentService = mkOption {
      type = types.bool;
      default = false;
      description = "Use ident service to query the name of the fingerer.";
    };

    hideFullNames = mkOption {
      type = types.bool;
      default = false;
      description = "Do not display users' full names.";
    };

    ignoreUserFiles = mkOption {
      type = types.bool;
      default = false;
      description = "Ignore user-specific .efingerd file.";
    };
  };

  config = mkIf cfg.enable {
    services.xinetd = {
      enable = true;
      services = singleton {
        name = "finger";
        user = cfg.user;
        server = "${cfg.package}/sbin/efingerd";
        serverArgs = concatStringsSep " " (
          (optional (cfg.connectionTimeout != null) "-t ${toString cfg.connectionTimeout}")
          ++ (optional cfg.noLookupAddresses "-n")
          ++ (optional cfg.useIdentService "-i")
          ++ (optional cfg.hideFullNames "-f")
          ++ (optional cfg.ignoreUserFiles "-u")
        );
      };
    };
  };
}
