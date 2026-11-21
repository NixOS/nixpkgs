{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.picom;

  # The options that only NixOS has.
  nixosModule = {
    # These are in the submodule, because a module outside it cannot declare
    # options below the `services.picom` option.
    imports = [
      (lib.mkRemovedOptionModule [ "refreshRate" ] ''
        This option corresponds to `refresh-rate`, which has been unused
        since picom v6 and was subsequently removed by upstream.
        See https://github.com/yshui/picom/commit/bcbc410
      '')
      (lib.mkRemovedOptionModule [ "experimentalBackends" ] ''
        This option was removed by upstream since picom v10.
      '')
    ];

    options = {
      # The modules above set this. The configuration of the system reads it.
      assertions = lib.mkOption {
        type = lib.types.listOf lib.types.unspecified;
        default = [ ];
        internal = true;
      };

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether or not to enable Picom as the X.org composite manager.
        '';
      };

      package = lib.mkPackageOption pkgs "picom" { };
    };
  };
in
{
  imports = [
    (lib.mkAliasOptionModule [ "services" "compton" ] [ "services" "picom" ])
  ];

  options.services.picom = lib.mkOption {
    default = { };
    description = "Configuration of the picom service.";

    # The options that map the settings to the configuration file are next to
    # the package, so that a system that does not use NixOS can use them too.
    # The import by path does not evaluate the package, see `pkgs.configFiles`.
    type = lib.types.submoduleWith {
      modules = [
        (pkgs.configFiles (import ../../../../pkgs/by-name/pi/picom/config-files.nix)).module
        nixosModule
      ];
    };
  };

  config = lib.mkMerge [
    { inherit (cfg) assertions; }

    (lib.mkIf cfg.enable {
      systemd.user.services.picom = {
        description = "Picom composite manager";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];

        # Temporarily fixes corrupt colours with Mesa 18
        environment = lib.mkIf (cfg.backend == "glx") {
          allow_rgb10_configs = "false";
        };

        serviceConfig = {
          ExecStart = "${lib.getExe cfg.package} --config ${cfg.portable.files."picom.conf".source}";
          RestartSec = 3;
          Restart = "always";
        };
      };

      environment.systemPackages = [ cfg.package ];
    })
  ];

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];
}
