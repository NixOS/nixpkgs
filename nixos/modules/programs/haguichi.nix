{ lib, pkgs, config, ... }:

with lib;

{
  options.programs.haguichi = {
    enable = mkEnableOption (lib.mdDoc "Haguichi, a Linux GUI frontend to the proprietary LogMeIn Hamachi");
  };

  config = mkIf config.programs.haguichi.enable {
    environment.systemPackages = with pkgs; [ haguichi ];

    services.logmein-hamachi.enable = true;
  };
}
