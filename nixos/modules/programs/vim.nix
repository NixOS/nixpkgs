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
    enable = lib.mkEnableOption "Vi IMproved, an advanced text editor";

    defaultEditor = lib.mkEnableOption "vim as the default editor";

    package = lib.mkPackageOption pkgs "vim" { example = [ "vim-full" ]; };
  };

  config = lib.mkIf (cfg.enable || cfg.defaultEditor) {
    assertions = [
      {
        assertion = cfg.defaultEditor -> cfg.enable;
        message = "{option}`programs.vim.defaultEditor` requires {option}`programs.vim.enable` to be set to true.";
      }
    ];
    environment = {
      systemPackages = [ cfg.package ];
      variables.EDITOR = lib.mkIf cfg.defaultEditor (lib.mkOverride 900 "vim");
      pathsToLink = [ "/share/vim-plugins" ];
    };
  };
}
