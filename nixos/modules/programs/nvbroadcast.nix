{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.nvbroadcast;
  boolToString = value: if value then "1" else "0";
  escapedCardLabel = lib.escape [ "\\" "\"" ] cfg.v4l2loopback.cardLabel;
in
{
  options.programs.nvbroadcast = {
    enable = lib.mkEnableOption "nvbroadcast, an AI-powered virtual camera and microphone application";

    package = lib.mkPackageOption pkgs "nvbroadcast" { };

    nvidia.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether to enable basic NVIDIA driver defaults for nvbroadcast.
      '';
    };

    pipewire.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = ''
        Whether to enable PipeWire and its PulseAudio-compatible server with
        default priority.
      '';
    };

    v4l2loopback = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = ''
          Whether to load and configure v4l2loopback for nvbroadcast virtual
          camera output.
        '';
      };

      videoNr = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 10;
        example = 42;
        description = ''
          Video device number for the v4l2loopback output device.
        '';
      };

      cardLabel = lib.mkOption {
        type = lib.types.str;
        default = "NVbroadcast";
        example = "NVIDIA Broadcast";
        description = ''
          Label for the v4l2loopback output device.
        '';
      };

      exclusiveCaps = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = ''
          Whether to enable exclusive capabilities for the v4l2loopback output
          device.
        '';
      };

      maxBuffers = lib.mkOption {
        type = lib.types.ints.positive;
        default = 4;
        example = 8;
        description = ''
          Maximum number of buffers for the v4l2loopback output device.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.pipewire = lib.mkIf cfg.pipewire.enable {
      enable = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
    };

    boot = lib.mkIf cfg.v4l2loopback.enable {
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      kernelModules = [ "v4l2loopback" ];
      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=${toString cfg.v4l2loopback.videoNr} card_label="${escapedCardLabel}" exclusive_caps=${boolToString cfg.v4l2loopback.exclusiveCaps} max_buffers=${toString cfg.v4l2loopback.maxBuffers}
      '';
    };

    hardware.graphics.enable = lib.mkIf cfg.nvidia.enable (lib.mkDefault true);
    services.xserver.videoDrivers = lib.mkIf cfg.nvidia.enable (lib.mkDefault [ "nvidia" ]);
  };

  meta = {
    maintainers = with lib.maintainers; [ Tenshock ];
    doc = ./nvbroadcast.md;
  };
}
