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

    package = lib.mkPackageOption pkgs "vim" { example = "vim-full"; };
  };

  # TODO: convert it into assert after 24.11 release
  config = lib.mkIf (cfg.enable || cfg.defaultEditor) {
    warnings = lib.mkIf (cfg.defaultEditor && !cfg.enable) [
      "programs.vim.defaultEditor will only work if programs.vim.enable is enabled, which will be enforced after the 24.11 release"
    ];
    environment = {
      systemPackages = [ cfg.package ];
      variables.EDITOR = lib.mkIf cfg.defaultEditor (lib.mkOverride 900 "vim");
      pathsToLink = [ "/share/vim-plugins" ];
    };
  };
}
