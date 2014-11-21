{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.scollector;

  collectors = pkgs.runCommand "collectors" {}
    ''
    mkdir -p $out
    ${lib.concatStringsSep
        "\n"
        (lib.mapAttrsToList
          (frequency: binaries:
            "mkdir -p $out/${frequency}\n" +
            (lib.concatStringsSep
              "\n"
              (map (path: "ln -s ${path} $out/${frequency}/$(basename ${path})")
                   binaries)))
          cfg.collectors)}
    '';

in {

  options = {

    services.scollector = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run scollector.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.scollector;
        example = literalExample "pkgs.scollector";
        description = ''
          scollector binary to use.
        '';
      };

      user = mkOption {
        type = types.string;
        default = "scollector";
        description = ''
          User account under which scollector runs.
        '';
      };

      group = mkOption {
        type = types.string;
        default = "scollector";
        description = ''
          Group account under which scollector runs.
        '';
      };

      bosunHost = mkOption {
        type = types.string;
        default = "localhost:8070";
        description = ''
          Host and port of the bosun server that will store the collected
          data.
        '';
      };

      collectors = mkOption {
        type = types.attrs;
        default = {};
        example = literalExample "{ 0 = [ \"\${postgresStats}/bin/collect-stats\" ]; }";
        description = ''
          An attribute set mapping the frequency of collection to a list of
          binaries that should be executed at that frequency. You can use "0"
          to run a binary forever.
        '';
      };

    };

  };

  config = mkIf config.services.scollector.enable {

    systemd.services.scollector = {
      description = "scollector metrics collector (part of Bosun)";
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.coreutils pkgs.iproute ];

      serviceConfig = {
        PermissionsStartOnly = true;
        User = cfg.user;
        Group = cfg.group;
        ExecStart = ''
          ${cfg.package}/bin/scollector -h=${cfg.bosunHost} -c=${collectors}
        '';
      };
    };

    users.extraUsers.scollector = {
      description = "scollector user";
      group = "scollector";
      uid = config.ids.uids.scollector;
    };

    users.extraGroups.scollector.gid = config.ids.gids.scollector;

  };

}
