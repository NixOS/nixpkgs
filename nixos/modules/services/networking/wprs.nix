{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe'
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;
  cfg = config.services.wprs;

  # Build CLI args from the settings attrset.
  mkArgs =
    settings:
    lib.concatLists (
      lib.mapAttrsToList (
        name: value:
        let
          v = if lib.isBool value then lib.boolToString value else toString value;
        in
        [
          "--${name}=${v}"
        ]
      ) settings
    );
in
{
  options.services.wprs = {
    enable = mkEnableOption "wprs, rootless remote desktop for Wayland";

    package = mkPackageOption pkgs "wprs" { };

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether wprsd should start automatically for logged-in users.
      '';
    };

    settings = mkOption {
      type = types.attrsOf (
        types.oneOf [
          types.str
          types.int
          types.bool
        ]
      );
      default = { };
      example = {
        framerate = 30;
        enable-xwayland = false;
      };
      description = ''
        Settings passed as CLI flags to wprsd.
        See `wprsd --help` for available options.
      '';
    };

    tuneNetworkBuffers = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to increase socket buffer limits for improved throughput.
        See <https://wiki.archlinux.org/title/sysctl#Increase_the_memory_dedicated_to_the_network_interfaces>.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # https://wiki.archlinux.org/title/sysctl#Increase_the_memory_dedicated_to_the_network_interfaces
    boot.kernel.sysctl = mkIf cfg.tuneNetworkBuffers {
      "net.core.rmem_default" = mkDefault 1048576;
      "net.core.rmem_max" = mkDefault 16777216;
      "net.core.wmem_default" = mkDefault 1048576;
      "net.core.wmem_max" = mkDefault 16777216;
    };

    systemd.user.services.wprsd = {
      description = "wprs rootless remote desktop daemon";
      wantedBy = mkIf cfg.autoStart [ "default.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = lib.concatStringsSep " " ([ (getExe' cfg.package "wprsd") ] ++ mkArgs cfg.settings);
        Restart = "on-failure";
        RestartSec = 5;
      };

      environment = {
        RUST_BACKTRACE = "1";
      };
    };
  };
}
