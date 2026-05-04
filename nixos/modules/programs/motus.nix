{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.motus;
in
{
  options.programs.motus = {
    enable = lib.mkEnableOption "motus, a dead simple password generator";

    package = lib.mkPackageOption pkgs "motus" { };

    enableClipboard = lib.mkOption {
      type = lib.types.bool;
      default = config.services.graphical-desktop.enable;
      defaultText = lib.literalExpression "config.services.graphical-desktop.enable";
      description = ''
        Whether to build motus with clipboard support. When enabled, generated
        passwords are automatically copied to the clipboard. Defaults to
        {option}`true` on systems with a graphical session configured and
        {option}`false` on headless systems.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (cfg.package.override { withClipboard = cfg.enableClipboard; })
    ];
  };
}
