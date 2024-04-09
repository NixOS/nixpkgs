{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.sedutil;

in {
  options.programs.sedutil.enable = mkEnableOption (lib.mdDoc "sedutil, to manage self encrypting drives that conform to the Trusted Computing Group OPAL 2.0 SSC specification");

  config = mkIf cfg.enable {
    boot.kernelParams = [
      "libata.allow_tpm=1"
    ];

    environment.systemPackages = with pkgs; [ sedutil ];
  };
}
