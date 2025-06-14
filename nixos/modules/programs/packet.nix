{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.packet;
in
{
  options = {
    programs.packet.enable = lib.mkEnableOption "the Packet Quick Share client for Linux";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.packet
      pkgs.nautilus-python
    ];
    environment.pathsToLink = [ "/share/nautilus-python/extensions" ];
  };
}
