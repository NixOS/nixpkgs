{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.windowManager.awesome;
  awesome = cfg.package;
  inherit (pkgs.luaPackages) getLuaPath getLuaCPath;
in

{

  ###### interface

  options = {

    services.xserver.windowManager.awesome = {

      enable = mkEnableOption "Awesome window manager";

      luaModules = mkOption {
        default = [];
        type = types.listOf types.package;
        description = "List of lua packages available for being used in the Awesome configuration.";
        example = literalExample "[ luaPackages.oocairo ]";
      };

      package = mkOption {
        default = null;
        type = types.nullOr types.package;
        description = "Package to use for running the Awesome WM.";
        apply = pkg: if pkg == null then pkgs.awesome else pkg;
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      { name = "awesome";
        start =
          ''
            export LUA_CPATH="${lib.concatStringsSep ";" (map getLuaCPath cfg.luaModules)}"
            export LUA_PATH="${lib.concatStringsSep ";" (map getLuaPath cfg.luaModules)}"

            ${awesome}/bin/awesome &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ awesome ];

  };
}
