{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.xserver.windowManager.awesome;
  awesome = cfg.package;
  getLuaPath = lib: dir: "${lib}/${dir}/lua/${awesome.lua.luaversion}";
  makeSearchPath = lib.concatMapStrings (
    path: " --search " + (getLuaPath path "share") + " --search " + (getLuaPath path "lib")
  );
in

{

  ###### interface

  options = {

    services.xserver.windowManager.awesome = {

      enable = lib.mkEnableOption "Awesome window manager";

      luaModules = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.package;
        description = "List of lua packages available for being used in the Awesome configuration.";
        example = lib.literalExpression "[ pkgs.luaPackages.vicious ]";
      };

      package = lib.mkPackageOption pkgs "awesome" { };

      noArgb = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Disable client transparency support, which can be greatly detrimental to performance in some setups";
      };
    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    services.xserver.windowManager.session = lib.singleton {
      name = "awesome";
      start = ''
        ${awesome}/bin/awesome ${lib.optionalString cfg.noArgb "--no-argb"} ${makeSearchPath cfg.luaModules} &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ awesome ];

  };
}
