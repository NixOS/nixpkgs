{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.logiops;
  # settingsFormat = pkgs.formats.libconfig {};
in {
  options.services.logiops = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable `logiops`, an unofficial driver for Logitech mice and keyboards.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Configuration for `logiops`, see
        <link xlink:href="https://github.com/PixlOne/logiops/wiki/Configuration"/>
        for supported values.
      '';
      example = ''
        devices: (
        {
            name: "Wireless Mouse MX Master";
            smartshift:
            {
                on: true;
                threshold: 30;
            };
            hiresscroll:
            {
                hires: true;
                invert: false;
                target: false;
            };
            dpi: 1000;

            buttons: (
                {
                    cid: 0xc3;
                    action =
                    {
                        type: "Gestures";
                        gestures: (
                            {
                                direction: "Up";
                                mode: "OnRelease";
                                action =
                                {
                                    type: "Keypress";
                                    keys: ["KEY_UP"];
                                };
                            },
                            {
                                direction: "Down";
                                mode: "OnRelease";
                                action =
                                {
                                    type: "Keypress";
                                    keys: ["KEY_DOWN"];
                                };
                            },
                            {
                                direction: "Left";
                                mode: "OnRelease";
                                action =
                                {
                                    type: "CycleDPI";
                                    dpis: [400, 600, 800, 1000, 1200, 1400, 1600];
                                };
                            },
                            {
                                direction: "Right";
                                mode: "OnRelease";
                                action =
                                {
                                    type = "ToggleSmartshift";
                                }
                            },
                            {
                                direction: "None"
                                mode: "NoPress"
                            }
                        );
                    };
                },
                {
                    cid: 0xc4;
                    action =
                    {
                        type: "Keypress";
                        keys: ["KEY_A"];
                    };
                }
            );
        }
        );
      '';
    };

    # settings = mkOption {
    #   type = types.submodule {
    #     # Declare that the settings option supports arbitrary format values, libconfig here
    #     freeformType = settingsFormat.type;
    #   };
    #   default = {};
    #   # Add upstream documentation to the settings description
    #   description = ''
    #     Configuration for `logiops`, see
    #     <link xlink:href="https://github.com/PixlOne/logiops/wiki/Configuration"/>
    #     for supported values.
    #   '';
    # };
  };

  config = mkIf cfg.enable {
    systemd.services.logiops = {
      description = "Logitech Configuration Daemon";
      startLimitIntervalSec = 0;
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.logiops}/bin/logid";
        User = "root";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
      };
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ pkgs.logiops ];
    };

    # environment.etc."logid.cfg".source = settingsFormat.generate "logid.cfg" cfg.settings;
    environment.etc."logid.cfg".text = cfg.extraConfig;
  };
}
