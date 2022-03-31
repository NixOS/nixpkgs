{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.zathura;

  formatLine = n: v:
    let
      formatValue = v:
        if isBool v then (if v then "true" else "false") else toString v;
    in ''set ${n}	"${formatValue v}"'';

in {

  options.programs.zathura = {
    enable = mkEnableOption ''
      Zathura, a highly customizable and functional document viewer
      focused on keyboard interaction'';

    package = mkOption {
      type = types.package;
      default = pkgs.zathura;
      defaultText = "pkgs.zathura";
      description = "The Zathura package to use";
    };

    options = mkOption {
      default = { };
      type = with types; attrsOf (either str (either bool int));
      description = ''
        Add <option>:set</option> command options to zathura and make
        them permanent. See
        <citerefentry>
          <refentrytitle>zathurarc</refentrytitle>
          <manvolnum>5</manvolnum>
        </citerefentry>
        for the full list of options.
      '';
      example = {
        default-bg = "#000000";
        default-fg = "#FFFFFF";
      };
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional commands for zathura that will be added to the
        <filename>zathurarc</filename> file.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];

      etc.zathurarc.source =
        pkgs.writeText "zathurarc" (concatStringsSep "\n" ([ ]
          ++ optional (cfg.extraConfig != "") cfg.extraConfig
          ++ mapAttrsToList formatLine cfg.options) + "\n");
    };

  };

  meta.maintainers = with maintainers; [ alexnortung ];
}
