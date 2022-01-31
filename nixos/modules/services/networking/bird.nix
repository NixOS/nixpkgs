{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption optionalString types;

  generic = variant:
    let
      cfg = config.services.${variant};
      pkg = pkgs.${variant};
      birdBin = if variant == "bird6" then "bird6" else "bird";
      birdc = if variant == "bird6" then "birdc6" else "birdc";
      descr =
        { bird = "1.6.x with IPv4 support";
          bird6 = "1.6.x with IPv6 support";
          bird2 = "2.x";
        }.${variant};
    in {
      ###### interface
      options = {
        services.${variant} = {
          enable = mkEnableOption "BIRD Internet Routing Daemon (${descr})";
          config = mkOption {
            type = types.lines;
            description = ''
              BIRD Internet Routing Daemon configuration file.
              <link xlink:href='http://bird.network.cz/'/>
            '';
          };
          checkConfig = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Whether the config should be checked at build time.
              When the config can't be checked during build time, for example when it includes
              other files, either disable this option or use <code>preCheckConfig</code> to create
              the included files before checking.
            '';
          };
          preCheckConfig = mkOption {
            type = types.lines;
            default = "";
            example = ''
              echo "cost 100;" > include.conf
            '';
            description = ''
              Commands to execute before the config file check. The file to be checked will be
              available as <code>${variant}.conf</code> in the current directory.

              Files created with this option will not be available at service runtime, only during
              build time checking.
            '';
          };
        };
      };

      ###### implementation
      config = mkIf cfg.enable {
        environment.systemPackages = [ pkg ];

        environment.etc."bird/${variant}.conf".source = pkgs.writeTextFile {
          name = "${variant}.conf";
          text = cfg.config;
          checkPhase = optionalString cfg.checkConfig ''
            ln -s $out ${variant}.conf
            ${cfg.preCheckConfig}
            ${pkg}/bin/${birdBin} -d -p -c ${variant}.conf
          '';
        };

        systemd.services.${variant} = {
          description = "BIRD Internet Routing Daemon (${descr})";
          wantedBy = [ "multi-user.target" ];
          reloadIfChanged = true;
          restartTriggers = [ config.environment.etc."bird/${variant}.conf".source ];
          serviceConfig = {
            Type = "forking";
            Restart = "on-failure";
            ExecStart = "${pkg}/bin/${birdBin} -c /etc/bird/${variant}.conf -u ${variant} -g ${variant}";
            ExecReload = "/bin/sh -c '${pkg}/bin/${birdBin} -c /etc/bird/${variant}.conf -p && ${pkg}/bin/${birdc} configure'";
            ExecStop = "${pkg}/bin/${birdc} down";
            CapabilityBoundingSet = [ "CAP_CHOWN" "CAP_FOWNER" "CAP_DAC_OVERRIDE" "CAP_SETUID" "CAP_SETGID"
                                      # see bird/sysdep/linux/syspriv.h
                                      "CAP_NET_BIND_SERVICE" "CAP_NET_BROADCAST" "CAP_NET_ADMIN" "CAP_NET_RAW" ];
            ProtectSystem = "full";
            ProtectHome = "yes";
            SystemCallFilter="~@cpu-emulation @debug @keyring @module @mount @obsolete @raw-io";
            MemoryDenyWriteExecute = "yes";
          };
        };
        users = {
          users.${variant} = {
            description = "BIRD Internet Routing Daemon user";
            group = variant;
            isSystemUser = true;
          };
          groups.${variant} = {};
        };
      };
    };

in

{
  imports = map generic [ "bird" "bird6" "bird2" ];
}
