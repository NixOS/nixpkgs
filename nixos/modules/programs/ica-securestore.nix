{ config, lib, pkgs, ... }:

{
  meta.maintainers = with lib.maintainers; [ jtojnar ];

  options = {
    programs.ica-securestore = {
      enable = lib.mkEnableOption (lib.mdDoc "I.CA SecureStore smart card manager");
    };
  };

  config = lib.mkIf config.programs.ica-securestore.enable {
    environment.systemPackages = [
      pkgs.ica-securestore
    ];
    environment.etc."ICA/cz.ica.SecureStore.ini".source = "${pkgs.ica-securestore}/etc/ICA/cz.ica.SecureStore.ini";
  };
}
