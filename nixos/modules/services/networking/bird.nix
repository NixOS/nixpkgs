{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  generic = variant:
    let
      cfg = config.services.${variant};
      pkg = pkgs.${variant};
      birdBin = if variant == "bird6" then "bird6" else "bird";
      birdc = if variant == "bird6" then "birdc6" else "birdc";
      descr =
        { bird = "1.9.x with IPv4 suport";
          bird6 = "1.9.x with IPv6 suport";
          bird2 = "2.x";
        }.${variant};
      configFile = pkgs.stdenv.mkDerivation {
        name = "${variant}.conf";
        text = cfg.config;
        preferLocalBuild = true;
        buildCommand = ''
          echo -n "$text" > $out
          ${pkg}/bin/${birdBin} -d -p -c $out
        '';
      };
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
        };
      };

      ###### implementation
      config = mkIf cfg.enable {
        environment.systemPackages = [ pkg ];
        systemd.services.${variant} = {
          description = "BIRD Internet Routing Daemon (${descr})";
          wantedBy = [ "multi-user.target" ];
          reloadIfChanged = true;
          serviceConfig = {
            Type = "forking";
            Restart = "on-failure";
            ExecStart = "${pkg}/bin/${birdBin} -c ${configFile} -u ${variant} -g ${variant}";
            ExecReload = "${pkg}/bin/${birdc} configure";
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
          };
          groups.${variant} = {};
        };
      };
    };

in

{
  imports = map generic [ "bird" "bird6" "bird2" ];
}
