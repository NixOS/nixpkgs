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
    if cfg.whitelist == [ ] && cfg.whitelistRegex == [ ] then
      hostsFile
    else
      let
        # the hostfile entries are in the form of "0.0.0.0 subdomain.domain.com"
        escapedWhitelist = lib.map (w: "^\\S+\\s${lib.escape [ "." ] w}$") cfg.whitelist;
        escapedWhitelistRegex = lib.map (r: "^\\S+\\s${lib.removePrefix "^" r}") cfg.whitelistRegex;
        pattern = lib.concatStringsSep "|" (escapedWhitelist ++ escapedWhitelistRegex);
      in
      pkgs.runCommand "filtered-hosts" { } ''
        sed -E '/${pattern}/d' ${hostsFile} > $out
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

    whitelistRegex = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Domain regular expressions to exclude from blocking.

        The regular expression must follows `sed`'s [ERE specs].

        [ERE specs]: https://www.gnu.org/software/sed/manual/html_node/ERE-syntax.html
      '';
      example = lib.literalExpression ''
        [ "^.*\\.donmai\\.us$" ]
      '';
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
