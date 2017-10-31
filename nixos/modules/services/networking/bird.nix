{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  generic = variant:
    let
      cfg = config.services.${variant};
      pkg = pkgs.${variant};
      birdc = if variant == "bird6" then "birdc6" else "birdc";
      configFile = pkgs.stdenv.mkDerivation {
        name = "${variant}.conf";
        text = cfg.config;
        preferLocalBuild = true;
        buildCommand = ''
          echo -n "$text" > $out
          ${pkg}/bin/${variant} -d -p -c $out
        '';
      };
    in {
      ###### interface
      options = {
        services.${variant} = {
          enable = mkEnableOption "BIRD Internet Routing Daemon";
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
          description = "BIRD Internet Routing Daemon";
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "forking";
            Restart = "on-failure";
            ExecStart = "${pkg}/bin/${variant} -c ${configFile} -u ${variant} -g ${variant}";
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
          extraUsers.${variant} = {
            description = "BIRD Internet Routing Daemon user";
            group = "${variant}";
          };
          extraGroups.${variant} = {};
        };
      };
    };

  inherit (config.services) bird bird6;
in {
  imports = [(generic "bird") (generic "bird6")];
}
