{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.vim;
in
{
  options.programs.vim = {
    enable = lib.mkEnableOption "Vi IMproved, an advanced text";

    defaultEditor = lib.mkEnableOption "vim as the default editor";

    package = lib.mkPackageOption pkgs "vim" { example = [ "vim-full" ]; };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      variables.EDITOR = lib.mkIf cfg.defaultEditor (lib.mkOverride 900 "vim");
      pathsToLink = [ "/share/vim-plugins" ];
    };
  };
}
