{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    lib.mkOption
    lib.optionalString
    types
    ;

  dataDir = "/var/lib/squeezelite";
  cfg = config.services.squeezelite;
  pkg = if cfg.pulseAudio then pkgs.squeezelite-pulse else pkgs.squeezelite;
  bin = "${pkg}/bin/${pkg.pname}";

in
{

  ###### interface

  options.services.squeezelite = {
    enable = lib.mkEnableOption "Squeezelite, a software Squeezebox emulator";

    pulseAudio = mkEnableOption "pulseaudio support";

    extraArguments = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = ''
        Additional command line arguments to pass to Squeezelite.
      '';
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    systemd.services.squeezelite = {
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "sound.target"
      ];
      description = "Software Squeezebox emulator";
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${bin} -N ${dataDir}/player-name ${cfg.extraArguments}";
        StateDirectory = builtins.baseNameOf dataDir;
        SupplementaryGroups = "audio";
      };
    };
  };
}
