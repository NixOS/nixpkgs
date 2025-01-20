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
    concatMapStringsSep
    optionalString
    ;

  cfg = config.services.shoko;
in
{
  options = {
    services.shoko = {
      enable = mkEnableOption "Shoko";

      package = mkPackageOption pkgs "shoko" { };
      webui = mkPackageOption pkgs "shoko-webui" { nullable = true; };
      plugins = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = "The plugins to install.";
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/shoko";
        description = "The directory where Shoko stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the ShokoAnime api and web interface.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "shoko";
        description = "User account under which Shoko runs.";
      };

      group = mkOption {
        type = types.str;
        default = "shoko";
        description = "Group under which Shoko runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    # 1. Create the data directory.
    # 2. If the webui is managed declaratively, delete the version that was
    #    there, if the webui wasn't managed declaratively beforehand
    #    (Shoko always copies a placeholder, or installs the real one if the
    #    user presses the specific button).
    # 3. Create the plugins directory if it doesn't exist, and remove every
    #    plugin that's a link to the nix store (this allows us to have
    #    imperative plugins as well), then symlink the specified plugins.
    system.activationScripts.shoko =
      ''
        install -dm700 '${cfg.dataDir}'
      ''
      + optionalString (cfg.webui != null) ''
        rm -rf '${cfg.dataDir}/webui'
        ln -s '${cfg.webui}' '${cfg.dataDir}/webui'
      ''
      + optionalString (cfg.plugins != [ ]) ''
        mkdir -p '${cfg.dataDir}/plugins'
        for file in '${cfg.dataDir}'/plugins/*; do
          [[ "$(readlink "$file")" == /nix/store/* ]] && rm -f "$file"
        done
        ${concatMapStringsSep "\n" (p: "ln -sf ${p} ${cfg.dataDir}/plugins") cfg.plugins}
      '';

    users = {
      users.shoko = mkIf (cfg.user == "shoko") {
        inherit (cfg) group;
        home = cfg.dataDir;
        isSystemUser = true;
        # It's created in the activation script to avoid ambiguity with which comes first
        # (this, or the activation script)
        createHome = false;
      };

      # Setting an attribute set doesn't work because of the module system's
      # quirks, so we set the name instead.
      groups.shoko.name = mkIf (cfg.group == "shoko") "shoko";
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 8111 ];

    systemd.services.shoko = {
      description = "Shoko";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment.SHOKO_HOME = cfg.dataDir;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = getExe cfg.package;
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = [ lib.maintainers.diniamo ];
}
