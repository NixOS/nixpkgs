{ config, pkgs, ... }:

with pkgs.lib;

let

  initScriptBuilder = pkgs.substituteAll {
    src = ./init-script-builder.sh;
    isExecutable = true;
    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
  };
  
in

{

  ###### interface

  options = {

    boot.loader.initScript = {

      enable = mkOption {
        default = true;
        description = ''
          Some systems require a /sbin/init script which is started.
          Or having it makes starting NixOS easier.
          This applies to some kind of hosting services and user mode linux.

          Additionaly this script will create
          /boot/init-other-configurations-contents.txt containing
          contents of remaining configurations. You can copy paste them into
          /sbin/init manually running a recue system or such.
        '';
      };
    };

  };
  

  ###### implementation

  config = {
  
    system.build.initScriptBuilder =
       if config.boot.loader.initScript.enable then initScriptBuilder else "";

  };
  
}
