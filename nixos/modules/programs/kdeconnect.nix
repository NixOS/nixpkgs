{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.programs.kdeconnect = {
    enable = lib.mkEnableOption ''
      kdeconnect.

      Note that it will open the TCP and UDP port from
      1714 to 1764 as they are needed for it to function properly.
      You can use the {option}`package` to use
      `gnomeExtensions.gsconnect` as an alternative
      implementation if you use Gnome
    '';
    package = lib.mkPackageOption pkgs [ "kdePackages" "kdeconnect-kde" ] {
      nullable = true;
      example = "gnomeExtensions.gsconnect";
    };
  };
  config =
    let
      cfg = config.programs.kdeconnect;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = lib.optional (cfg.package != null) [
        cfg.package
      ];
      networking.firewall = rec {
        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = allowedTCPPortRanges;
      };
    };
}
