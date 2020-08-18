{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.windowManager.awesome;
  awesome = cfg.package;
  getLuaPath = lib : dir : "${lib}/${dir}/lua/${pkgs.luaPackages.lua.luaversion}";
  makeSearchPath = lib.concatMapStrings (path:
    " --search " + (getLuaPath path "share") +
    " --search " + (getLuaPath path "lib")
  );
  awesomeWrapped = pkgs.buildEnv {
    name = "awesome-wrapper";
    paths = [ (writeScriptBin "awesome" ''
      exec ${awesome}/bin/awesome ${lib.optionalString cfg.noArgb "--no-argb"} ${makeSearchPath cfg.luaModules} "$@"
    '')];
  };
in {

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

      noArgb = mkOption {
        default = false;
        type = types.bool;
        description = "Disable client transparency support, which can be greatly detrimental to performance in some setups";
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      { name = "awesome";
        start =
          ''
            ${awesomeWrapped}/bin/.awesome-wrapped &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ awesomeWrapped ];

  };
}
