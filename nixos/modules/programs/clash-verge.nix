{ config, lib, pkgs, ... }:

{
  options.programs.clash-verge = {
<<<<<<< HEAD
    enable = lib.mkEnableOption (lib.mdDoc "Clash Verge");
    autoStart = lib.mkEnableOption (lib.mdDoc "Clash Verge auto launch");
    tunMode = lib.mkEnableOption (lib.mdDoc "Clash Verge TUN mode");
=======
    enable = lib.mkEnableOption (lib.mdDoc ''
      Clash Verge.
    '');

    autoStart = lib.mkEnableOption (lib.mdDoc ''
      Clash Verge Auto Launch.
    '');

    tunMode = lib.mkEnableOption (lib.mdDoc ''
      Clash Verge Tun Mode.
    '');
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  config =
    let
      cfg = config.programs.clash-verge;
    in
    lib.mkIf cfg.enable {

      environment.systemPackages = [
        pkgs.clash-verge
        (lib.mkIf cfg.autoStart (pkgs.makeAutostartItem {
          name = "clash-verge";
          package = pkgs.clash-verge;
        }))
      ];

      security.wrappers.clash-verge = lib.mkIf cfg.tunMode {
        owner = "root";
        group = "root";
        capabilities = "cap_net_bind_service,cap_net_admin=+ep";
        source = "${lib.getExe pkgs.clash-verge}";
      };
    };

  meta.maintainers = with lib.maintainers; [ zendo ];
}
