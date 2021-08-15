{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.nzbget;
  pkg = pkgs.nzbget;
  stateDir = "/var/lib/nzbget";
  configFile = if cfg.declarativeConfig == null then
                 "${stateDir}/nzbget.conf"
               else
                 "/run/nzbget/nzbget.conf";
  declarativeConfigFile = pkgs.writeText "nzbget.conf" (generators.toKeyValue {} cfg.declarativeConfig);
  defaultConfigFile = "${pkg}/share/nzbget/nzbget.conf";
  configOpts = concatStringsSep " " (mapAttrsToList (name: value: "-o ${name}=${value}") nixosOpts);

  nixosOpts = {
    # allows nzbget to run as a "simple" service
    OutputMode = "loggable";
    # use journald for logging
    WriteLog = "none";
    ErrorTarget = "screen";
    WarningTarget = "screen";
    InfoTarget = "screen";
    DetailTarget = "screen";
    # required paths
    ConfigTemplate = "${pkg}/share/nzbget/nzbget.conf";
    WebDir = "${pkg}/share/nzbget/webui";
    # nixos handles package updates
    UpdateCheck = "none";
  };

in
{
  imports = [
    (mkRemovedOptionModule [ "services" "misc" "nzbget" "configFile" ] "The configuration of nzbget is now managed by users through the web interface.")
    (mkRemovedOptionModule [ "services" "misc" "nzbget" "dataDir" ] "The data directory for nzbget is now /var/lib/nzbget.")
    (mkRemovedOptionModule [ "services" "misc" "nzbget" "openFirewall" ] "The port used by nzbget is managed through the web interface so you should adjust your firewall rules accordingly.")
  ];

  # interface

  options = {
    services.nzbget = {
      enable = mkEnableOption "NZBGet";

      user = mkOption {
        type = types.str;
        default = "nzbget";
        description = "User account under which NZBGet runs";
      };

      group = mkOption {
        type = types.str;
        default = "nzbget";
        description = "Group under which NZBGet runs";
      };

      declarativeConfig = mkOption {
        type = with types; nullOr (attrsOf (oneOf [ int str ]));
        default = null;
        description = ''
          NZBGet configuration options, if used the configuration cannot be
          modified by NZBGet.
        '';
      };

      appendConfigFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          NZBGet config file that is added to and overwrites the declarative
          configuration. This can be useful for specifying passwords or other
          secrets. This option is ignored if <option>declarativeConfig</option>
          is unset.
        '';
      };
    };
  };

  # implementation

  config = mkIf cfg.enable {
    systemd.services.nzbget = {
      description = "NZBGet Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        unrar
        p7zip
      ];
      preStart = if cfg.declarativeConfig == null then ''
        if [ ! -f ${configFile} ]; then
          ${pkgs.coreutils}/bin/install -m 0700 ${pkg}/share/nzbget/nzbget.conf ${configFile}
        fi
      '' else ''
        set -u
        # parse config files in order overwriting options and dump the resulting configuration
        IFS='
        '
        declare -A options
        for file in ${
          escapeShellArgs ([ defaultConfigFile declarativeConfigFile ]
                           ++ optional (cfg.appendConfigFile != null) cfg.appendConfigFile)
        }; do
          while read -r line; do
            [[ $line =~ ^# || $line =~ ^\ *$ ]] || options["''${line%%=*}"]="$line"
          done < "$file"
        done
        for line in "''${options[@]}"; do
          printf '%s\n' "$line"
        done | install -m 0400 /dev/stdin ${configFile}
      '';

      serviceConfig = {
        StateDirectory = "nzbget";
        StateDirectoryMode = "0750";
        User = cfg.user;
        Group = cfg.group;
        UMask = "0002";
        Restart = "on-failure";
        ExecStart = "${pkg}/bin/nzbget --server --configfile ${configFile} ${configOpts}";
        ExecStop = "${pkg}/bin/nzbget --quit";
      } // optionalAttrs (cfg.declarativeConfig != null) {
        RuntimeDirectory = "nzbget";
      };
    };

    users.users = mkIf (cfg.user == "nzbget") {
      nzbget = {
        home = stateDir;
        group = cfg.group;
        uid = config.ids.uids.nzbget;
      };
    };

    users.groups = mkIf (cfg.group == "nzbget") {
      nzbget = {
        gid = config.ids.gids.nzbget;
      };
    };
  };
}
