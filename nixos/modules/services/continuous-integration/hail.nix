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
      description = lib.mdDoc ''
        Enables the Hail Auto Update Service. Hail can automatically deploy artifacts
        built by a Hydra Continous Integration server. A common use case is to provide
        continous deployment for single services or a full NixOS configuration.'';
    };
    profile = mkOption {
      type = types.str;
      default = "hail-profile";
      description = lib.mdDoc "The name of the Nix profile used by Hail.";
    };
    hydraJobUri = mkOption {
      type = types.str;
      description = lib.mdDoc "The URI of the Hydra Job.";
    };
    netrc = mkOption {
      type = types.nullOr types.path;
      description = lib.mdDoc "The netrc file to use when fetching data from Hydra.";
      default = null;
    };
    package = mkOption {
      type = types.package;
      default = pkgs.haskellPackages.hail;
      defaultText = literalExpression "pkgs.haskellPackages.hail";
      description = lib.mdDoc "Hail package to use.";
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
