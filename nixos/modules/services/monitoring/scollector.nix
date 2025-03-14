{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.scollector;

  collectors = pkgs.runCommand "collectors" { preferLocalBuild = true; } ''
    mkdir -p $out
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        frequency: binaries:
        "mkdir -p $out/${frequency}\n"
        + (lib.concatStringsSep "\n" (
          map (path: "ln -s ${path} $out/${frequency}/$(basename ${path})") binaries
        ))
      ) cfg.collectors
    )}
  '';

  conf = pkgs.writeText "scollector.toml" ''
    Host = "${cfg.bosunHost}"
    ColDir = "${collectors}"
    ${cfg.extraConfig}
  '';

in
{

  options = {

    services.scollector = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to run scollector.
        '';
      };

      package = lib.mkPackageOption pkgs "scollector" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "scollector";
        description = ''
          User account under which scollector runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "scollector";
        description = ''
          Group account under which scollector runs.
        '';
      };

      bosunHost = lib.mkOption {
        type = lib.types.str;
        default = "localhost:8070";
        description = ''
          Host and port of the bosun server that will store the collected
          data.
        '';
      };

      collectors = lib.mkOption {
        type = with lib.types; attrsOf (listOf path);
        default = { };
        example = lib.literalExpression ''{ "0" = [ "''${postgresStats}/bin/collect-stats" ]; }'';
        description = ''
          An attribute set mapping the frequency of collection to a list of
          binaries that should be executed at that frequency. You can use "0"
          to run a binary forever.
        '';
      };

      extraOpts = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        example = [ "-d" ];
        description = ''
          Extra scollector command line options
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra scollector configuration added to the end of scollector.toml
        '';
      };

    };

  };

  config = lib.mkIf config.services.scollector.enable {

    systemd.services.scollector = {
      description = "scollector metrics collector (part of Bosun)";
      wantedBy = [ "multi-user.target" ];

      path = [
        pkgs.coreutils
        pkgs.iproute2
      ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/scollector -conf=${conf} ${lib.concatStringsSep " " cfg.extraOpts}";
      };
    };

    users.users.scollector = {
      description = "scollector user";
      group = "scollector";
      uid = config.ids.uids.scollector;
    };

    users.groups.scollector.gid = config.ids.gids.scollector;

  };

}
