{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.jai-jail;

in
{
  options.programs.jai-jail = {
    enable = lib.mkEnableOption "jai, a sandbox for AI agents";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.jai-jail;
      defaultText = lib.literalExpression "pkgs.jai-jail";
      description = "The jai package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.jai = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cfg.package}/bin/jai";
    };

    users.users.jai = {
      isSystemUser = true;
      group = "jai";
      home = "/";
      description = "JAI sandbox untrusted user";
    };

    users.groups.jai = { };

    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ agentelement ];
}
