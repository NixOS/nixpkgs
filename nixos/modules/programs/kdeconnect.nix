{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.kdeconnect;
in
{
  options.programs.kdeconnect = {
    enable = lib.mkEnableOption ''
      kdeconnect.

      Note that by default it will open the TCP and UDP ports from
      1714 to 1764 as they are needed for it to function properly.
      See {option}`openFirewall` to control this behavior.
      You can use the {option}`package` to use
      `gnomeExtensions.gsconnect` as an alternative
      implementation if you use Gnome
    '';
    package = lib.mkPackageOption pkgs [ "kdePackages" "kdeconnect-kde" ] {
      nullable = true;
      example = "gnomeExtensions.gsconnect";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      defaultText = lib.literalExpression "config.programs.kdeconnect.enable";
      description = ''
        Whether to open the required TCP and UDP ports (1714-1764) needed by KDE Connect.
      '';
    };
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = lib.optionals (cfg.package != null) [
        cfg.package
      ];
    })
    (lib.mkIf cfg.openFirewall (
      let
        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
      in
      {
        networking.firewall = {
          inherit allowedTCPPortRanges;
          allowedUDPPortRanges = allowedTCPPortRanges;
        };
      }
    ))
  ];
}
