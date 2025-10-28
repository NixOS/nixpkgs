{
  config,
  lib,
  pkgs,
  ...
}:

{
  meta.maintainers = [ lib.maintainers.mic92 ];

  ###### interface
  options = {
    programs.adb = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to configure system to use Android Debug Bridge (adb).
        '';
      };
    };
  };

  ###### implementation
  config = lib.mkIf config.programs.adb.enable {
    environment.systemPackages = [ pkgs.android-tools ];
  };
}
