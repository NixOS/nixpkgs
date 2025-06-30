{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.programs.htop;

  fmt =
    value:
    if builtins.isList value then
      builtins.concatStringsSep " " (builtins.map fmt value)
    else if builtins.isString value then
      value
    else if builtins.isBool value then
      if value then "1" else "0"
    else if builtins.isInt value then
      builtins.toString value
    else
      throw "Unrecognized type ${builtins.typeOf value} in htop settings";

in

{

  options.programs.htop = {
    package = lib.mkPackageOption pkgs "htop" { };

    enable = lib.mkEnableOption "htop process monitor";

    settings = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          str
          int
          bool
          (listOf (oneOf [
            str
            int
            bool
          ]))
        ]);
      default = { };
      example = {
        hide_kernel_threads = true;
        hide_userland_threads = true;
      };
      description = ''
        Extra global default configuration for htop
        which is read on first startup only.
        Htop subsequently uses ~/.config/htop/htoprc
        as configuration source.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    environment.etc."htoprc".text =
      ''
        # Global htop configuration
        # To change set: programs.htop.settings.KEY = VALUE;
      ''
      + builtins.concatStringsSep "\n" (
        lib.mapAttrsToList (key: value: "${key}=${fmt value}") cfg.settings
      );
  };

}
