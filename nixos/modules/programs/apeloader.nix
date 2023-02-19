{ config, lib, pkgs, ... }:

let
  cfg = config.programs.apeloader;
in
{
  options.programs.apeloader.enable = lib.mkEnableOption
    "support for Actually Portable Executable binaries";
  options.programs.apeloader.package = lib.mkOption {
    description = "The apeloader package";
    type = lib.types.package;
    default = pkgs.apeloader;
    defaultText = lib.literalExpression "pkgs.apeloader";
  };

  config = lib.mkIf cfg.enable {
    boot.binfmt.registrations.APE = {
      recognitionType = "magic";
      magicOrExtension = "MZqFpD";
      interpreter = "${cfg.package}/bin/ape";
    };
  };
}
