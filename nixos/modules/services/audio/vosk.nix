{ config, lib, pkgs, ... }:
let
  cfg = config.services.vosk;
in
{
  options.services.vosk = with lib; {
    enable = mkEnableOption (lib.mdDoc "the Vosk WebSocket speech recognition server");
    package = mkOption {
      type = types.package;
      default = pkgs.vosk-server;
      defaultText = literalExpression "pkgs.vosk-server";
      description = lib.mdDoc "The package to use for the Vosk server.";
    };
    interface = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = lib.mdDoc "Interface the Vosk server should bind to.";
    };
    port = mkOption {
      type = types.port;
      default = 2700;
      description = lib.mdDoc "Port the Vosk server should listen on.";
    };
    model = mkOption {
      type = types.path;
      default = pkgs.vosk.models.en-us;
      defaultText = literalExpression "pkgs.vosk.models.en-us";
      example = literalExpression "pkgs.vosk.models.de";
      description = lib.mdDoc "Model the Vosk server should use.";
    };
    spkModel = mkOption {
      type = types.nullOr types.path;
      default = pkgs.vosk.models.spk;
      defaultText = literalExpression "pkgs.vosk.models.spk";
      description = lib.mdDoc "Speaker identification model the Vosk server should use.";
    };
    sampleRate = mkOption {
      type = types.int;
      default = 8000;
      description = lib.mdDoc "Sample rate the Vosk server should use.";
    };
    maxAlternatives = mkOption {
      type = types.int;
      default = 0;
      description = lib.mdDoc "The number of alternative guesses the Vosk server should return.";
    };
    showWords = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc "Whether the Vosk server should return timestamps for recognised words.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.vosk = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        HOME = "/var/empty"; # vosk-server fails if it can’t resolve HOME

        VOSK_SERVER_INTERFACE = cfg.interface;
        VOSK_SERVER_PORT = toString cfg.port;
        VOSK_MODEL_PATH = cfg.model;
        VOSK_SAMPLE_RATE = toString cfg.sampleRate;
        VOSK_ALTERNATIVES = toString cfg.maxAlternatives;
        VOSK_SHOW_WORDS = toString cfg.showWords;
      } // (lib.optionalAttrs (!(isNull cfg.spkModel)) {
        VOSK_SPK_MODEL_PATH = cfg.spkModel;
      });
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/vosk-server";

        # from systemd-analyze --no-pager security vosk.service
        CapabilityBoundingSet = null;
        DynamicUser = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
      };
    };
  };
}
