{ config, lib, pkgs, ... }:

let
  cfg = config.programs.kde-pim;
in
{
  options.programs.kde-pim = {
    enable = lib.mkEnableOption "KDE PIM base packages";
    kmail = lib.mkEnableOption "KMail";
    kontact = lib.mkEnableOption "Kontact";
    merkuro = lib.mkEnableOption "Merkuro";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs.kdePackages; [
      # core packages
      akonadi
      kdepim-runtime
    ] ++ lib.optionals cfg.kmail [
      akonadiconsole
      akonadi-search
      kmail
      kmail-account-wizard
    ] ++ lib.optionals cfg.kontact [
      kontact
    ] ++ lib.optionals cfg.merkuro [
      merkuro
    ];
  };
}
