{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nixos.jobserver;
  tokenDir = "/run/nixos-jobserver";
  tokenFile = "${tokenDir}/tokens";
in
{
  options = {
    nixos.jobserver = {
      enable = mkEnableOption "the global NixOS jobserver";

      owner = mkOption {
        type = types.str;
        default = "root";
        description = ''
          Owner of the jobserver token file.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "nixbld";
        description = ''
          Group of the jobserver token file.
        '';
      };

      tokens = mkOption {
        type = types.ints.unsigned;
        default = 0;
        description = ''
          Number of tokens to provide via the jobserver. Uses the number of CPUs in the
          system when set to 0.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    nix.sandboxPaths = [ "/jobserver=${tokenFile}?" ];

    systemd.services.nixos-jobserver = {
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.nixos-jobserver pkgs.util-linux ];

      preStart = ''
        mkdir -p ${tokenDir}

        umask 0777
        touch ${tokenFile}
      '';

      script = ''
        nixos-jobserver \
          -t ${toString cfg.tokens} \
          -u ${escapeShellArg cfg.owner} \
          -g ${escapeShellArg cfg.group} \
          ${tokenFile}
      '';

      # we explicitly *do not* kill the jobserver.
      # doing so would cause all running builds to fail.
      # instead we want to make the jobserver unavailable to new builds, but allow
      # running builds to finish and the jobserver to exit once they're all done.
      # systemd *does not* want to allow this kind of thing, so we instruct it to
      # only kill the wrapper script. with the token file unmounted the jobserver
      # process will exit once all builds have finished.
      preStop = ''
        umount ${tokenFile}
      '';
      serviceConfig.KillMode = "process";
    };
  };
}
