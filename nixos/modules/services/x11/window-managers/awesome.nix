{ config, lib, pkgs, ... }:

with lib;

let

  wmcfg = config.services.xserver.windowManager;
  cfg = emcfg.awesome;
  awesome = cfg.package;

in

{

  ###### interface

  options = {

    services.xserver.windowManager.awesome = {

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

  config = mkIf (elem "awesome" wmcfg.enable) {

    services.xserver.windowManager.session = singleton
      { name = "awesome";
        start =
          ''
            ${concatMapStrings (pkg: ''
              export LUA_CPATH=$LUA_CPATH''${LUA_CPATH:+;}${pkg}/lib/lua/${awesome.lua.luaversion}/?.so
              export LUA_PATH=$LUA_PATH''${LUA_PATH:+;}${pkg}/lib/lua/${awesome.lua.luaversion}/?.lua
            '') cfg.luaModules}

            ${awesome}/bin/awesome &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ awesome ];

  };

}
