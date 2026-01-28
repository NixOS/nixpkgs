{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.stash-clipboard;
  inherit (lib)
    mkPackageOption
    mkEnableOption
    mkOption
    types
    mkIf
    getExe
    concatStringsSep
    ;
in
{
  options.services.stash-clipboard = {
    enable = mkEnableOption "stash, a Wayland clipboard manager";

    package = mkPackageOption pkgs [ "stash-clipboard" ] { };

    flags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--max-items 10" ];
      description = "Flags to pass to stash watch.";
    };

    filterFile = mkOption {
      type = types.str;
      default = "";
      example = "/etc/stash/clipboard_filter";
      description = ''
        Stash can be configured to avoid storing clipboard entries that match a sensitive pattern, using a regular expression.
        The file set here should contain your regex pattern (no quotes).

        Example regex to block common password patterns:
        - (password|secret|api[_-]?key|token)[=: ]+[^\s]+
      '';
    };

    excludedApps = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "Bitwarden" ];
      description = ''
        List of application classes to exclude from the database.
        Entries from these apps are still copied to the clipboard, but it will never be put inside the database.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd = {
      user.services.stash-clipboard = {
        description = "Stash clipboard manager daemon";
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${getExe cfg.package} ${concatStringsSep " " cfg.flags} watch";
          LoadCredential = mkIf (cfg.filterFile != "") "clipboard_filter:${cfg.filterFile}";
        };
        environment = mkIf (cfg.excludedApps != [ ]) {
          STASH_EXCLUDED_APPS = concatStringsSep "," cfg.excludedApps;
        };
      };
    };
  };
}
