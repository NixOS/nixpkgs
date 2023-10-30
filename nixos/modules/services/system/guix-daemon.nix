{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.guix;
in {
  options = with lib; {
    guix = {
      enable = mkEnableOption "guix";

      package = mkOption {
        type = with types; package;
        default = pkgs.guix;
        defaultText = literalExpression "pkgs.guix";
        description = mdDoc ''
          This option specifies the Guix package to be used in the system.
        '';
      };

      substituteUrls = mkOption {
        type = with types; listOf str;
        default = [
          "https://ci.guix.gnu.org"
          "https://bordeaux.guix.gnu.org"
        ];
        description = mdDoc ''
          List of urls to be used as substituters.
        '';
      };

      cores = mkOption {
        type = with types; int;
        default = 0;
        description = mdDoc ''
          Number of CPU cores to build each derivation, 0 means as many as available.
        '';
      };

      maxJobs = mkOption {
        type = with types; int;
        default = 1;
        description = mdDoc ''
          Allow at most n build jobs in parallel. The default value is 1. Setting it to 0 means that no builds will be performed locally; instead, the daemon will offload builds (see Using the Offload Facility), or simply fail.
        '';
      };

      extraArgs = mkOption {
        type = with types; listOf (coercedTo anything (x: "${x}") str);
        default = [];
        description = mdDoc ''
          Extra flags passed to guix-daemon. Inteded for flags that don't have a setting equivalent.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    systemd.services.guix-daemon = {
      path = [cfg.package];
      script = ''
        ${cfg.package}/bin/guix-daemon \
          --build-users-group=nixbld \
          --substitute-urls='${lib.escapeShellArgs cfg.substituteUrls}'
      '';
      wantedBy = ["multi-user.target"];
    };
  };
}
