{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.kde-pim;
  mkProgramOption =
    name:
    lib.mkEnableOption name
    // {
      default = cfg.enable;
      defaultText = "config.programs.kde-pim.enable";
    };
in
{
  options.programs.kde-pim = {
    enable = lib.mkEnableOption "KDE PIM base packages";
    kmail = mkProgramOption "KMail";
    kontact = mkProgramOption "Kontact";
    merkuro = mkProgramOption "Merkuro";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      with pkgs.kdePackages;
      [
        # core packages
        akonadi
        akonadi-import-wizard
        kdepim-runtime
      ]
      ++ lib.optionals cfg.kmail [
        akonadiconsole
        akonadi-search
        kmail
        kmail-account-wizard
      ]
      ++ lib.optionals cfg.kontact [
        kontact
      ]
      ++ lib.optionals cfg.merkuro (
        [
          merkuro
        ]
        # Only needed when using the Merkuro Contacts widget in Plasma.
        ++ lib.optionals config.services.desktopManager.plasma6.enable [
          kcontacts
          akonadi-contacts
        ]
      );
  };
}
