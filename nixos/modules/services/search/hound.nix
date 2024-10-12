{ config, lib, pkgs, ... }:
let
  cfg = config.services.hound;
  settingsFormat = pkgs.formats.json { };
in {
  imports = [
    (lib.mkRemovedOptionModule [ "services" "hound" "extraGroups" ] "Use users.users.hound.extraGroups instead")
    (lib.mkChangedOptionModule [ "services" "hound" "config" ] [ "services" "hound" "settings" ] (config: builtins.fromJSON config.services.hound.config))
  ];

  meta.maintainers = with lib.maintainers; [ SuperSandro2000 ];

  options = {
    services.hound = {
      enable = lib.mkEnableOption "hound";

      package = lib.mkPackageOption pkgs "hound" { };

      user = lib.mkOption {
        default = "hound";
        type = lib.types.str;
        description = ''
          User the hound daemon should execute under.
        '';
      };

      group = lib.mkOption {
        default = "hound";
        type = lib.types.str;
        description = ''
          Group the hound daemon should execute under.
        '';
      };

      home = lib.mkOption {
        default = "/var/lib/hound";
        type = lib.types.path;
        description = ''
          The path to use as hound's $HOME.
          If the default user "hound" is configured then this is the home of the "hound" user.
        '';
      };

      settings = lib.mkOption {
        type = settingsFormat.type;
        example = lib.literalExpression ''
          {
            max-concurrent-indexers = 2;
            repos.nixpkgs.url = "https://www.github.com/NixOS/nixpkgs.git";
          }
        '';
        description = ''
          The full configuration of the Hound daemon.
          See the upstream documentation <https://github.com/hound-search/hound/blob/main/docs/config-options.md> for details.

          :::{.note}
          The `dbpath` should be an absolute path to a writable directory.
          :::.com/hound-search/hound/blob/main/docs/config-options.md>.
        '';
      };

      listen = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0:6080";
        example = ":6080";
        description = ''
          Listen on this [IP]:port
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups = lib.mkIf (cfg.group == "hound") {
      hound = { };
    };

    users.users = lib.mkIf (cfg.user == "hound") {
      hound = {
        description = "Hound code search";
        createHome = true;
        isSystemUser = true;
        inherit (cfg) home group;
      };
    };

    environment.etc."hound/config.json".source = pkgs.writeTextFile {
      name = "hound-config";
      text = builtins.toJSON cfg.settings;
      checkPhase = ''
        ${cfg.package}/bin/houndd -check-conf -conf $out
      '';
    };

    services.hound.settings = {
      dbpath = "${config.services.hound.home}/data";
    };

    systemd.services.hound = {
      description = "Hound Code Search";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.home;
        ExecStartPre = "${pkgs.git}/bin/git config --global --replace-all http.sslCAinfo /etc/ssl/certs/ca-certificates.crt";
        ExecStart = "${cfg.package}/bin/houndd -addr ${cfg.listen} -conf /etc/hound/config.json";
      };
    };
  };
}
