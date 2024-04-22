{ lib, config, pkgs, ... }:

let
  cfg = config.programs.appimage;
in

{
  options.programs.appimage = {
    enable = lib.mkEnableOption "appimage-run wrapper script for executing appimages on NixOS";
    binfmt = lib.mkEnableOption "binfmt registration to run appimages via appimage-run seamlessly";
    package = lib.mkPackageOption pkgs "appimage-run" {
      example = ''
        pkgs.appimage-run.override {
          extraPkgs = pkgs: [ pkgs.ffmpeg pkgs.imagemagick ];
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.binfmt.registrations.appimage = lib.mkIf cfg.binfmt {
      wrapInterpreterInShell = false;
      interpreter = lib.getExe cfg.package;
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ jopejoe1 atemu ];
}
