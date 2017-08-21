{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.hail;
in {


  ###### interface

  options.services.hail = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Hail Auto Update Service.";
    };
    profile = mkOption {
      type = types.str;
      default = "hail-profile";
      description = "The name of the Nix profile used by Hail.";
    };
    hydraJobUri = mkOption {
      type = types.str;
      description = "The URI of the Hydra Job.";
    };
    netrc = mkOption {
      type = types.nullOr types.path;
      description = "The netrc file to use when fetching data from Hydra.";
      default = null;
    };
    package = mkOption {
      type = types.package;
      default = pkgs.haskellPackages.hail;
      defaultText = "pkgs.haskellPackages.hail";
      description = "Hail package to use.";
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.hail = {
      description = "Hail Auto Update Service";
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ nix ];
      environment = {
        HOME = "/var/lib/empty";
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/hail --profile ${cfg.profile} --job-uri ${cfg.hydraJobUri}"
          + lib.optionalString (cfg.netrc != null) " --netrc-file ${cfg.netrc}";
      };
    };
  };
}
