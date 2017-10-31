# Global configuration for atop.

{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.atop;

in
{
  ###### interface

  options = {

    programs.atop = {

      settings = mkOption {
        type = types.attrs;
        default = {};
        example = {
          flags = "a1f";
          interval = 5;
        };
        description = ''
          Parameters to be written to <filename>/etc/atoprc</filename>.
        '';
      };

    };
  };

  config = mkIf (cfg.settings != {}) {
    environment.etc."atoprc".text =
      concatStrings (mapAttrsToList (n: v: "${n} ${toString v}\n") cfg.settings);
  };
}
