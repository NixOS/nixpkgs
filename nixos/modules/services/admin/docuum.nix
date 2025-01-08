{
  config,
  pkgs,
  lib,
  utils,
  ...
}:

let
  cfg = config.services.docuum;
  inherit (lib)
    mkIf
    mkEnableOption
    lib.mkOption
    getExe
    types
    lib.optionals
    concatMap
    ;
in
{
  options.services.docuum = {
    enable = lib.mkEnableOption "docuum daemon";

    threshold = lib.mkOption {
      description = "Threshold for deletion in bytes, like `10 GB`, `10 GiB`, `10GB` or percentage-based thresholds like `50%`";
      type = lib.types.str;
      default = "10 GB";
      example = "50%";
    };

    minAge = lib.mkOption {
      description = "Sets the minimum age of images to be considered for deletion.";
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "1d";
    };

    keep = lib.mkOption {
      description = "Prevents deletion of images for which repository:tag matches the specified regex.";
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "^my-image" ];
    };

    deletionChunkSize = lib.mkOption {
      description = "Removes specified quantity of images at a time.";
      type = lib.types.int;
      default = 1;
      example = 10;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.virtualisation.docker.enable;
        message = "docuum requires docker on the host";
      }
    ];

    systemd.services.docuum = {
      after = [ "docker.socket" ];
      requires = [ "docker.socket" ];
      wantedBy = [ "multi-user.target" ];
      path = [ config.virtualisation.docker.package ];
      environment.HOME = "/var/lib/docuum";

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "docuum";
        SupplementaryGroups = [ "docker" ];
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (getExe pkgs.docuum)
            "--threshold"
            cfg.threshold
            "--deletion-chunk-size"
            cfg.deletionChunkSize
          ]
          ++ (concatMap (keep: [
            "--keep"
            keep
          ]) cfg.keep)
          ++ (optionals (cfg.minAge != null) [
            "--min-age"
            cfg.minAge
          ])
        );
      };
    };
  };
}
