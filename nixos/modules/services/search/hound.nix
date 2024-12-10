{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.hound;
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "hound"
      "extraGroups"
    ] "Use users.users.hound.extraGroups instead")
  ];

  meta.maintainers = with maintainers; [ SuperSandro2000 ];

  options = {
    services.hound = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the hound code search daemon.
        '';
      };

      package = mkPackageOptionMD pkgs "hound" { };

      user = mkOption {
        default = "hound";
        type = types.str;
        description = ''
          User the hound daemon should execute under.
        '';
      };

      group = mkOption {
        default = "hound";
        type = types.str;
        description = ''
          Group the hound daemon should execute under.
        '';
      };

      home = mkOption {
        default = "/var/lib/hound";
        type = types.path;
        description = ''
          The path to use as hound's $HOME.
          If the default user "hound" is configured then this is the home of the "hound" user.
        '';
      };

      config = mkOption {
        type = types.str;
        description = ''
          The full configuration of the Hound daemon. Note the dbpath
          should be an absolute path to a writable location on disk.
        '';
        example = literalExpression ''
          {
            "max-concurrent-indexers" : 2,
            "repos" : {
                "nixpkgs": {
                  "url" : "https://www.github.com/NixOS/nixpkgs.git"
                }
            }
          }
        '';
      };

      listen = mkOption {
        type = types.str;
        default = "0.0.0.0:6080";
        example = ":6080";
        description = ''
          Listen on this [IP]:port
        '';
      };
    };
  };

  config = mkIf cfg.enable {
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

    systemd.services.hound =
      let
        configFile = pkgs.writeTextFile {
          name = "hound.json";
          text = cfg.config;
          checkPhase = ''
            # check if the supplied text is valid json
            ${lib.getExe pkgs.jq} . $target > /dev/null
          '';
        };
      in
      {
        description = "Hound Code Search";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.home;
          ExecStartPre = "${pkgs.git}/bin/git config --global --replace-all http.sslCAinfo /etc/ssl/certs/ca-certificates.crt";
          ExecStart = "${cfg.package}/bin/houndd -addr ${cfg.listen} -conf ${configFile}";
        };
      };
  };
}
