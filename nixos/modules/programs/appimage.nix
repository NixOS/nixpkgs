{ lib, config, pkgs, ... }:

let
  cfg = config.programs.appimage;
  finalPackage = cfg.package.override {extraPkgs = pkgs: cfg.extraPackages;};
in

{
  options = {
    programs.appimage = {
      enable = lib.mkEnableOption (lib.mdDoc "appimage-run");
      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = lib.mdDoc ''
          List of packages to provide to appimage-run.
        '';
      };
      binfmt = lib.mkEnableOption (lib.mdDoc "binfmt to directly execute AppImage's");
      package = lib.mkPackageOption pkgs "appimage-run" { };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.binfmt.registrations.appimage = lib.mkIf cfg.binfmt {
      wrapInterpreterInShell = false;
      interpreter = lib.getExe finalPackage;
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    environment.systemPackages = [ finalPackage ];
  };

  meta.maintainers = with lib.maintainers; [ jopejoe1 ];
}
