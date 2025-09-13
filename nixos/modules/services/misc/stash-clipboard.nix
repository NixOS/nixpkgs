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
    ;
in
{
  options.services.stash-clipboard = {
    enable = mkEnableOption "stash, a Wayland clipboard manager";

    package = mkPackageOption pkgs [ "stash-clipboard" ] { };

    flags = mkOption {
      type = types.str;
      default = "";
      example = "--max-items 10";
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
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd = {
      packages = [ cfg.package ];
      user.services.stash-clipboard = {
        enable = true;
        description = "Stash clipboard manager daemon";
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${getExe cfg.package} ${cfg.flags} watch";
          LoadCredential = mkIf (cfg.filterFile != "") "clipboard_filter:${cfg.filterFile}";
        };
      };
    };
  };
}
