{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.hound;
in {
  options = {
    services.hound = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the hound code search daemon.
        '';
      };

      user = mkOption {
        default = "hound";
        type = types.str;
        description = lib.mdDoc ''
          User the hound daemon should execute under.
        '';
      };

      group = mkOption {
        default = "hound";
        type = types.str;
        description = lib.mdDoc ''
          Group the hound daemon should execute under.
        '';
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "dialout" ];
        description = lib.mdDoc ''
          List of extra groups that the "hound" user should be a part of.
        '';
      };

      home = mkOption {
        default = "/var/lib/hound";
        type = types.path;
        description = lib.mdDoc ''
          The path to use as hound's $HOME. If the default user
          "hound" is configured then this is the home of the "hound"
          user.
        '';
      };

      package = mkOption {
        default = pkgs.hound;
        defaultText = literalExpression "pkgs.hound";
        type = types.package;
        description = lib.mdDoc ''
          Package for running hound.
        '';
      };

      config = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The full configuration of the Hound daemon. Note the dbpath
          should be an absolute path to a writable location on disk.
        '';
        example = literalExpression ''
          '''
            {
              "max-concurrent-indexers" : 2,
              "dbpath" : "''${services.hound.home}/data",
              "repos" : {
                  "nixpkgs": {
                    "url" : "https://www.github.com/NixOS/nixpkgs.git"
                  }
              }
            }
          '''
        '';
      };

      listen = mkOption {
        type = types.str;
        default = "0.0.0.0:6080";
        example = "127.0.0.1:6080 or just :6080";
        description = lib.mdDoc ''
          Listen on this IP:port / :port
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups = optionalAttrs (cfg.group == "hound") {
      hound.gid = config.ids.gids.hound;
    };

    users.users = optionalAttrs (cfg.user == "hound") {
      hound = {
        description = "hound code search";
        createHome = true;
        home = cfg.home;
        group = cfg.group;
        extraGroups = cfg.extraGroups;
        uid = config.ids.uids.hound;
      };
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
        ExecStart = "${cfg.package}/bin/houndd" +
                    " -addr ${cfg.listen}" +
                    " -conf ${pkgs.writeText "hound.json" cfg.config}";

      };
      path = [ pkgs.git pkgs.mercurial pkgs.openssh ];
    };
  };

}
