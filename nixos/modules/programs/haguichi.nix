{
  lib,
  pkgs,
  config,
  ...
}:

{
  options.programs.haguichi = {
    enable = lib.mkEnableOption "Haguichi, a Linux GUI frontend to the proprietary LogMeIn Hamachi";
  };

  config = lib.mkIf config.programs.haguichi.enable {
    environment.systemPackages = with pkgs; [ haguichi ];

    services.logmein-hamachi.enable = true;
  };
}
