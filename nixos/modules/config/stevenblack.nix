{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getOutput
    maintainers
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.networking.stevenblack;

  filterHostsFile =
    hostsFile:
    if cfg.whitelist == [ ] then
      hostsFile
    else
      let
        pattern = lib.escape [ "." "|" ] (lib.concatStringsSep "|" cfg.whitelist);
      in
      pkgs.runCommand "filtered-hosts" { } ''
        sed '/${pattern}/d' ${hostsFile} > $out
      '';
in
{
  options.networking.stevenblack = {
    enable = mkEnableOption "the stevenblack hosts file blocklist";

    package = mkPackageOption pkgs "stevenblack-blocklist" { };

    block = mkOption {
      type = types.listOf (
        types.enum [
          "fakenews"
          "gambling"
          "porn"
          "social"
        ]
      );
      default = [ ];
      description = "Additional blocklist extensions.";
    };

    whitelist = mkOption {
      # https://datatracker.ietf.org/doc/html/rfc1035
      type = types.listOf (types.strMatching "^[a-zA-Z0-9_-]+([.][a-zA-Z0-9_-]+)+$");
      default = [ ];
      description = "Domains to exclude from blocking.";
      example = [ "s.click.aliexpress.com" ];
    };
  };

  config = mkIf cfg.enable {
    networking.hostFiles = map (x: filterHostsFile "${getOutput x cfg.package}/hosts") (
      [ "ads" ] ++ cfg.block
    );
  };

  meta.maintainers = with maintainers; [
    moni
    artturin
    frontear
  ];
}
