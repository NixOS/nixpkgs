{ config, pkgs, lib, ... }:

with lib;

let cfg = config.programs.noisetorch;
in
{
  options.programs.noisetorch = {
    enable = mkEnableOption "noisetorch + setcap wrapper";

    package = mkOption {
      type = types.package;
      default = pkgs.noisetorch;
      defaultText = literalExpression "pkgs.noisetorch";
      description = lib.mdDoc ''
        The noisetorch package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    security.wrappers.noisetorch = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_resource=+ep";
      source = "${cfg.package}/bin/noisetorch";
    };
    environment.systemPackages = [ cfg.package ];
  };
}
