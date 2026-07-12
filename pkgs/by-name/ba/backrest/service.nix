# Non-module dependencies (`importApply`)
{
  bash,
  symlinkJoin,
  makeBinaryWrapper,
}:

# Service module
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib)
    getExe
    literalExpression
    mkOption
    types
    ;
  cfg = config.backrest;

  backrestWrapped = symlinkJoin {
    name = "backrest-wrapped";
    paths = [ cfg.package ];
    nativeBuildInputs = [ makeBinaryWrapper ];
    postBuild = ''
      wrapProgram $out/bin/backrest \
        ${
          lib.optionalString (cfg.extraPackages != [ ]) "--prefix PATH : ${lib.makeBinPath cfg.extraPackages}"
        } \
        --set-default BACKREST_PORT ${cfg.address}:${toString cfg.port} \
        --set-default BACKREST_DATA ${cfg.dataDir} \
        ${lib.optionalString (cfg.configPath != null) "--set-default BACKREST_CONFIG ${cfg.configPath}"}
    '';
    meta.mainProgram = "backrest";
  };
in
{
  # https://nixos.org/manual/nixos/unstable/#modular-services
  _class = "service";

  options = {
    backrest = {
      package = mkOption {
        description = "Package to use for backrest.";
        defaultText = "The backrest package that provided this module.";
        type = types.package;
      };

      address = mkOption {
        description = "Address to listen on.";
        type = types.str;
        default = "127.0.0.1";
      };

      port = mkOption {
        description = "Port to listen on.";
        type = types.port;
        default = 9898;
      };

      dataDir = mkOption {
        description = "Directory for internal data.";
        type = types.str;
        default = "/var/lib/backrest";
      };

      configPath = mkOption {
        description = "Path to config.json.";
        type = types.nullOr types.str;
        default = null;
      };

      extraArgs = mkOption {
        description = "Extra arguments to pass to backrest.";
        type = types.listOf types.str;
        default = [ ];
      };

      extraPackages = mkOption {
        description = "Extra packages to add make available to backrest's PATH, useful for backrest hooks.";
        type = types.listOf types.package;
        defaultText = literalExpression "[ pkgs.bash ]"; # TODO: can I use pkgs in modular services?
        default = [ bash ];
      };
    };
  };

  config = {
    process.argv = [
      (getExe backrestWrapped)
    ]
    ++ cfg.extraArgs;
  }
  // lib.optionalAttrs (options ? systemd) {
    systemd.service = {
      after = [ "network.target" ];
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "always";
        DynamicUser = true;
        StateDirectory = "backrest";
        Environment = "HOME=${cfg.dataDir}";
        AmbientCapabilities = [ "CAP_DAC_READ_SEARCH" ];
        CapabilityBoundingSet = [ "CAP_DAC_READ_SEARCH" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ phanirithvij ];
}
