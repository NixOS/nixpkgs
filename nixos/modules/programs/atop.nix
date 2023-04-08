# Global configuration for atop.

{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.atop;

in
{
  ###### interface

  options = {

    programs.atop = rec {

      enable = mkEnableOption (lib.mdDoc "Atop");

      package = mkOption {
        type = types.package;
        default = pkgs.atop;
        defaultText = literalExpression "pkgs.atop";
        description = lib.mdDoc ''
          Which package to use for Atop.
        '';
      };

      netatop = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
            Whether to install and enable the netatop kernel module.
            Note: this sets the kernel taint flag "O" for loading out-of-tree modules.
          '';
        };
        package = mkOption {
          type = types.package;
          default = config.boot.kernelPackages.netatop;
          defaultText = literalExpression "config.boot.kernelPackages.netatop";
          description = lib.mdDoc ''
            Which package to use for netatop.
          '';
        };
      };

      atopgpu.enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to install and enable the atopgpud daemon to get information about
          NVIDIA gpus.
        '';
      };

      setuidWrapper.enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to install a setuid wrapper for Atop. This is required to use some of
          the features as non-root user (e.g.: ipc information, netatop, atopgpu).
          Atop tries to drop the root privileges shortly after starting.
        '';
      };

      atopService.enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable the atop service responsible for storing statistics for
          long-term analysis.
        '';
      };
      atopRotateTimer.enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable the atop-rotate timer, which restarts the atop service
          daily to make sure the data files are rotate.
        '';
      };
      atopacctService.enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable the atopacct service which manages process accounting.
          This allows Atop to gather data about processes that disappeared in between
          two refresh intervals.
        '';
      };
      settings = mkOption {
        type = types.attrs;
        default = { };
        example = {
          flags = "a1f";
          interval = 5;
        };
        description = lib.mdDoc ''
          Parameters to be written to {file}`/etc/atoprc`.
        '';
      };
    };
  };

  config = mkIf cfg.enable (
    let
      atop =
        if cfg.atopgpu.enable then
          (cfg.package.override { withAtopgpu = true; })
        else
          cfg.package;
    in
    {
      environment.etc = mkIf (cfg.settings != { }) {
        atoprc.text = concatStrings
          (mapAttrsToList
            (n: v: ''
              ${n} ${toString v}
            '')
            cfg.settings);
      };
      environment.systemPackages = [ atop (lib.mkIf cfg.netatop.enable cfg.netatop.package) ];
      boot.extraModulePackages = [ (lib.mkIf cfg.netatop.enable cfg.netatop.package) ];
      systemd =
        let
          mkSystemd = type: cond: name: restartTriggers: {
            ${name} = lib.mkIf cond {
              inherit restartTriggers;
              wantedBy = [ (if type == "services" then "multi-user.target" else if type == "timers" then "timers.target" else null) ];
            };
          };
          mkService = mkSystemd "services";
          mkTimer = mkSystemd "timers";
        in
        {
          packages = [ atop (lib.mkIf cfg.netatop.enable cfg.netatop.package) ];
          services =
            mkService cfg.atopService.enable "atop" [ atop ]
            // lib.mkIf cfg.atopService.enable {
              # always convert logs to newer version first
              # XXX might trigger TimeoutStart but restarting atop.service will
              # convert remainings logs and start eventually
              atop.serviceConfig.ExecStartPre = pkgs.writeShellScript "atop-update-log-format" ''
                set -e -u
                shopt -s nullglob
                for logfile in "$LOGPATH"/atop_*
                do
                  ${atop}/bin/atopconvert "$logfile" "$logfile".new
                  # only replace old file if version was upgraded to avoid
                  # false positives for atop-rotate.service
                  if ! ${pkgs.diffutils}/bin/cmp -s "$logfile" "$logfile".new
                  then
                    ${pkgs.coreutils}/bin/mv -v -f "$logfile".new "$logfile"
                  else
                    ${pkgs.coreutils}/bin/rm -f "$logfile".new
                  fi
                done
              '';
            }
            // mkService cfg.atopacctService.enable "atopacct" [ atop ]
            // mkService cfg.netatop.enable "netatop" [ cfg.netatop.package ]
            // mkService cfg.atopgpu.enable "atopgpu" [ atop ];
          timers = mkTimer cfg.atopRotateTimer.enable "atop-rotate" [ atop ];
        };

      security.wrappers = lib.mkIf cfg.setuidWrapper.enable {
        atop =
          { setuid = true;
            owner = "root";
            group = "root";
            source = "${atop}/bin/atop";
          };
      };
    }
  );
}
