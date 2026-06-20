{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    mkEnableOption
    mkPackageOption
    getExe
    optionalString
    ;

  cfg = config.services.shoko;

  shokoPlugins = pkgs.linkFarm "shoko-plugins" (
    map (pkg: {
      inherit (pkg) name;
      path = "${pkg}/lib/${pkg.pname}";
    }) cfg.plugins
  );
in
{
  options = {
    services.shoko = {
      enable = mkEnableOption "Shoko";

      package = mkPackageOption pkgs "shoko" { };
      webui = mkPackageOption pkgs "shoko-webui" { nullable = true; };
      plugins = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = ''
          The plugins to install.

          Note that if there are plugins installed imperatively when this
          option is used, they will be deleted.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the ShokoAnime api and web interface.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 8111 ];

    systemd.services.shoko = {
      description = "Shoko Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      # Not that it should be done, but this makes it easier to override the
      # StateDirectory option, if the user really wants to.
      environment.SHOKO_HOME = "/var/lib/${config.systemd.services.shoko.serviceConfig.StateDirectory}";

      # The rm calls are here, because it's pretty easy to get into a situation
      # where those directories are created imperatively, in which case the ln
      # calls (along with the service) would just fail.
      preStart =
        optionalString (cfg.webui != null) ''
          rm -rf "$STATE_DIRECTORY/webui"
          ln -s '${cfg.webui}' "$STATE_DIRECTORY/webui"
        ''
        + optionalString (cfg.plugins != [ ]) ''
          rm -rf "$STATE_DIRECTORY/plugins"
          ln -s '${shokoPlugins}' "$STATE_DIRECTORY/plugins"
        '';

      serviceConfig = {
        Type = "simple";

        DynamicUser = true;
        StateDirectory = "shoko";
        StateDirectoryMode = 750;

        ExecStart = getExe cfg.package;
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    diniamo
    nanoyaki
  ];
}
