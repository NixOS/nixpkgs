{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.aerothemeplasma;

  aeroKdePackages = pkgs.kdePackages.aerothemeplasmaPackages;
in
{
  options.programs.aerothemeplasma = {
    enable = lib.mkEnableOption null // {
      description = ''
        Whether to enable AeroThemePlasma.

        This is a project which aims to recreate the look and feel of Windows 7
        as much as possible on KDE Plasma, whilst adapting the design to fit in
        with modern features provided by KDE Plasma and Linux.
      '';
    };

    kwinComponents.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install SMOD and the AeroShell KWin components.";
    };

    assets.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install the unfree Windows 7 icon, cursor, and sound themes.";
    };

    uacAgent.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether AeroThemePlasma sessions use the UAC Polkit Agent.";
    };

    sddm.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to use AeroThemePlasma's Windows 7 SDDM theme.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.desktopManager.plasma6.enable;
        message = "programs.aerothemeplasma requires services.desktopManager.plasma6.enable = true.";
      }
    ];

    environment.systemPackages = [
      aeroKdePackages.aerothemeplasma
      pkgs.kdePackages.qtstyleplugin-kvantum
    ]
    ++ lib.optionals cfg.kwinComponents.enable [
      pkgs.kdePackages.smod
      pkgs.kdePackages.aeroshell-kwin-components
    ]
    ++ lib.optionals cfg.assets.enable [
      pkgs.kdePackages.aerothemeplasma-icons
      pkgs.kdePackages.aerothemeplasma-sounds
    ];

    services.displayManager = {
      sessionPackages = [ aeroKdePackages.aerothemeplasma ];

      sddm = {
        theme = lib.mkIf cfg.sddm.enable (
          lib.mkOverride 900 "${aeroKdePackages.aerothemeplasma}/share/sddm/themes/sddm-theme-mod"
        );

        # The SDDM theme imports QtMultimedia, so add it to the greeter environment
        extraPackages = lib.mkIf cfg.sddm.enable [ pkgs.kdePackages.qtmultimedia ];
      };
    };

    # Stock sessions need stock libplasma, so select plasmashell by session
    systemd.user.services.plasma-plasmashell = {
      overrideStrategy = "asDropin";
      serviceConfig.ExecStart = [
        ""
        ''/bin/sh -c "if [ \"$PLASMA_DEFAULT_SHELL\" = ${aeroKdePackages.aerothemeplasma.shellId} ]; then exec ${lib.getBin aeroKdePackages.plasma-workspace}/bin/plasmashell --no-respawn; else exec ${lib.getBin pkgs.kdePackages.plasma-workspace}/bin/plasmashell --no-respawn; fi"''
      ];
    };

    # Stock sessions need KDE's agent, so select the polkit agent by session
    systemd.user.services.plasma-polkit-agent = lib.mkIf cfg.uacAgent.enable {
      overrideStrategy = "asDropin";
      serviceConfig.ExecStart = [
        ""
        ''/bin/sh -c "if [ -n \"$USE_UAC_AGENT\" ]; then exec ${pkgs.kdePackages.aeroshell-uac-polkit-agent}/libexec/uac-polkit-agent; else exec ${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1; fi"''
      ];
    };
  };

  meta.maintainers = with lib.maintainers; [ aaravrav ];
}
