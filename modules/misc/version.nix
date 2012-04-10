{ config, pkgs, ... }:

with pkgs.lib;

{

  options = {
  
    system.nixosVersion = mkOption {
      default =
        builtins.readFile ../../.version
        + (if builtins.pathExists ../../.version-suffix then builtins.readFile ../../.version-suffix else "pre-svn");
      description = "NixOS version.";
    };
    
  };

}
