{
  lib,
  config,
  stdenv,
  _pkgs,
  ...
}:

{
  options = {
    SDL2 = lib.mkOption {
      type = lib.types.bool;
      default = lib.meta.availableOn stdenv.hostPlatform _pkgs.SDL2;
      description = ''
        Enable SDL2 interface.
      '';
    };
    X11 = lib.mkOption {
      type = lib.types.bool;
      default = lib.meta.availableOn stdenv.hostPlatform _pkgs.libX11;
      description = ''
        Enable X11 interface.
      '';
    };
    term = lib.mkOption {
      type = lib.types.bool;
      default = lib.meta.availableOn stdenv.hostPlatform _pkgs.ncurses;
      description = ''
        Enable ncurses terminal interface.
      '';
    };
    wx = lib.mkOption {
      type = lib.types.bool;
      default = lib.meta.availableOn stdenv.hostPlatform _pkgs.wxGTK32;
      description = ''
        Enable wxWidgets interface.
      '';
    };
  };
}
