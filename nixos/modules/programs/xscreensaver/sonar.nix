{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.xscreensaver.sonar;
  globalCfg = config.programs.xscreensaver;
in
{
  options.programs.xscreensaver.sonar = {
    enable = lib.mkEnableOption "xscreensaver";
  };
  config = lib.mkIf cfg.enable {
    security.wrappers.sonar = {
      capabilities = "cap_net_raw+ep";
      owner = "root";
      group = "root";
      source =
        let
          script = pkgs.writeShellScript "sonar-fakeroot" ''
            ${pkgs.fakeroot}/bin/fakeroot ${globalCfg.package}/libexec/xscreensaver/sonar "$@"
          '';
        in
        script;
    };
  };
}
