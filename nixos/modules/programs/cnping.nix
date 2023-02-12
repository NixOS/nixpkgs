{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.cnping;
in
{
  options = {
    programs.cnping = {
      enable = mkEnableOption (lib.mdDoc "Whether to install a setcap wrapper for cnping");
      package = mkOption {
        default = pkgs.cnping;
        type = types.package;
        defaultText = literalExpression "pkgs.cnping";
        description = lib.mdDoc "cnping derivation to use";
      };
    };
  };

  config = mkIf cfg.enable {
    security.wrappers.cnping = {
      source = "${cfg.package}/bin/cnping";
      capabilities = "cap_net_raw+ep";
    };
  };
}
