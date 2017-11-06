{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.nixup-tools;

  managed-packages =
    let
      packagesString = if cfg.managed-packages-path == null
                       then let xdg_config_home_ = builtins.getEnv "XDG_CONFIG_HOME";
                                xdg_config_home = if xdg_config_home_ == "" then "${builtins.getEnv "HOME"}/.config" else xdg_config_home_;
                            in
                            if builtins.pathExists "${xdg_config_home}/nixup/packages.nix"
                            then readFile (builtins.toPath "${xdg_config_home}/nixup/packages.nix")
                            else ""
                       else if builtins.pathExists (builtins.toPath cfg.managed-packages-path)
                            then readFile (builtins.toPath cfg.managed-packages-path)
                            else "";
    in
      map (x : getAttr x pkgs) (remove "" (map (x: replaceChars ["\n"] [""] x) (splitString "\n" packagesString)));

in

{
  options = {

    nixup-tools = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable special tooling for NixUP.
        '';
      };
      managed-packages-path = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = ''
          Path of file to include into "user.packages".
          "null" uses "$XDG_CONFIG_HOME/nixup/packages.nix".
        '';
      };
    };
  };

  config = {

    user.packages = mkIf cfg.enable ([ pkgs.nixup-tools ] ++ managed-packages);

  };
}
