{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.windowManager.awesome;
  awesome = cfg.package;
  getLuaPath = lib: dir: "${lib}/${dir}/lua/${awesome.lua.luaversion}";
  makeSearchPath = lib.concatMapStrings (path:
    " --search " + (getLuaPath path "share") +
    " --search " + (getLuaPath path "lib")
  );
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
        example = literalExpression "[ pkgs.luaPackages.vicious ]";
      };

      package = mkPackageOption pkgs "awesome" { };

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
            ${awesome}/bin/awesome ${lib.optionalString cfg.noArgb "--no-argb"} ${makeSearchPath cfg.luaModules} &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ awesome ];

  };
}
