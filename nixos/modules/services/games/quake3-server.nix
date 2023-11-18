{ config, pkgs, lib, ... }:

let
  inherit (lib) literalMD mkEnableOption mkIf mkOption types;
  cfg = config.services.quake3-server;

  configFile = pkgs.writeText "q3ds-extra.cfg" ''
    set net_port ${builtins.toString cfg.port}

    ${cfg.extraConfig}
  '';

  defaultBaseq3 = pkgs.requireFile rec {
    name = "baseq3";
    hashMode = "recursive";
    sha256 = "5dd8ee09eabd45e80450f31d7a8b69b846f59738726929298d8a813ce5725ed3";
    message = ''
      Unfortunately, we cannot download ${name} automatically.
      Please purchase a legitimate copy of Quake 3 and change into the installation directory.

      You can either add all relevant files to the nix-store like this:
      mkdir /tmp/baseq3
      cp baseq3/pak*.pk3 /tmp/baseq3
      nix-store --add-fixed sha256 --recursive /tmp/baseq3

      Alternatively you can set services.quake3-server.baseq3 to a path and copy the baseq3 directory into
      $services.quake3-server.baseq3/.q3a/
    '';
  };

  home = pkgs.runCommand "quake3-home" {} ''
      mkdir -p $out/.q3a/baseq3

      for file in ${cfg.baseq3}/*; do
        ln -s $file $out/.q3a/baseq3/$(basename $file)
      done

      ln -s ${configFile} $out/.q3a/baseq3/nix.cfg
  '';
in {
  options = {
    services.quake3-server = {
      enable = mkEnableOption (lib.mdDoc "Quake 3 dedicated server");
      package = lib.mkPackageOptionMD pkgs "ioquake3" { };

      port = mkOption {
        type = types.port;
        default = 27960;
        description = lib.mdDoc ''
          UDP Port the server should listen on.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open the firewall.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          seta rconPassword "superSecret"      // sets RCON password for remote console
          seta sv_hostname "My Quake 3 server"      // name that appears in server list
        '';
        description = lib.mdDoc ''
          Extra configuration options. Note that options changed via RCON will not be persisted. To list all possible
          options, use "cvarlist 1" via RCON.
        '';
      };

      baseq3 = mkOption {
        type = types.either types.package types.path;
        default = defaultBaseq3;
        defaultText = literalMD "Manually downloaded Quake 3 installation directory.";
        example = "/var/lib/q3ds";
        description = lib.mdDoc ''
          Path to the baseq3 files (pak*.pk3). If this is on the nix store (type = package) all .pk3 files should be saved
          in the top-level directory. If this is on another filesystem (e.g /var/lib/baseq3) the .pk3 files are searched in
          $baseq3/.q3a/baseq3/
        '';
      };
    };
  };

  config = let
    baseq3InStore = builtins.typeOf cfg.baseq3 == "set";
  in mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.q3ds = {
      description = "Quake 3 dedicated server";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];

      environment.HOME = if baseq3InStore then home else cfg.baseq3;

      serviceConfig = with lib; {
        Restart = "always";
        DynamicUser = true;
        WorkingDirectory = home;

        # It is possible to alter configuration files via RCON. To ensure reproducibility we have to prevent this
        ReadOnlyPaths = if baseq3InStore then home else cfg.baseq3;
        ExecStartPre = optionalString (!baseq3InStore) "+${pkgs.coreutils}/bin/cp ${configFile} ${cfg.baseq3}/.q3a/baseq3/nix.cfg";

        ExecStart = "${cfg.package}/bin/ioq3ded +exec nix.cfg";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ f4814n ];
}
