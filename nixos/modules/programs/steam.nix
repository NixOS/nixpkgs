{ config, lib, pkgs, ... }:

let
  cfg = config.programs.steam;
  gamescopeCfg = config.programs.gamescope;

  steam-gamescope = let
    exports = builtins.attrValues (builtins.mapAttrs (n: v: "export ${n}=${v}") cfg.gamescopeSession.env);
  in
    pkgs.writeShellScriptBin "steam-gamescope" ''
      ${builtins.concatStringsSep "\n" exports}
      gamescope --steam ${builtins.toString cfg.gamescopeSession.args} -- steam -tenfoot -pipewire-dmabuf
    '';

  gamescopeSessionFile =
    (pkgs.writeTextDir "share/wayland-sessions/steam.desktop" ''
      [Desktop Entry]
      Name=Steam
      Comment=A digital distribution platform
      Exec=${steam-gamescope}/bin/steam-gamescope
      Type=Application
    '').overrideAttrs (_: { passthru.providedSessions = [ "steam" ]; });
in {
  options.programs.steam = {
    enable = lib.mkEnableOption "steam";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.steam;
      defaultText = lib.literalExpression "pkgs.steam";
      example = lib.literalExpression ''
        pkgs.steam-small.override {
          extraEnv = {
            MANGOHUD = true;
            OBS_VKCAPTURE = true;
            RADV_TEX_ANISO = 16;
          };
          extraLibraries = p: with p; [
            atk
          ];
        }
      '';
      apply = steam: steam.override (prev: {
        extraEnv = (lib.optionalAttrs (cfg.extraCompatPackages != [ ]) {
          STEAM_EXTRA_COMPAT_TOOLS_PATHS = lib.makeSearchPathOutput "steamcompattool" "" cfg.extraCompatPackages;
        }) // (lib.optionalAttrs cfg.extest.enable {
          LD_PRELOAD = "${pkgs.pkgsi686Linux.extest}/lib/libextest.so";
        }) // (prev.extraEnv or {});
        extraLibraries = pkgs: let
          prevLibs = if prev ? extraLibraries then prev.extraLibraries pkgs else [ ];
          additionalLibs = with config.hardware.opengl;
            if pkgs.stdenv.hostPlatform.is64bit
            then [ package ] ++ extraPackages
            else [ package32 ] ++ extraPackages32;
        in prevLibs ++ additionalLibs;
      } // lib.optionalAttrs (cfg.gamescopeSession.enable && gamescopeCfg.capSysNice)
      {
        buildFHSEnv = pkgs.buildFHSEnv.override {
          # use the setuid wrapped bubblewrap
          bubblewrap = "${config.security.wrapperDir}/..";
        };
      });
      description = ''
        The Steam package to use. Additional libraries are added from the system
        configuration to ensure graphics work properly.

        Use this option to customise the Steam package rather than adding your
        custom Steam to {option}`environment.systemPackages` yourself.
      '';
    };

    extraCompatPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression ''
        with pkgs; [
          proton-ge-bin
        ]
      '';
      description = ''
        Extra packages to be used as compatibility tools for Steam on Linux. Packages will be included
        in the `STEAM_EXTRA_COMPAT_TOOLS_PATHS` environmental variable. For more information see
        https://github.com/ValveSoftware/steam-for-linux/issues/6310.

        These packages must be Steam compatibility tools that have a `steamcompattool` output.
      '';
    };

    remotePlay.openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open ports in the firewall for Steam Remote Play.
      '';
    };

    dedicatedServer.openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open ports in the firewall for Source Dedicated Server.
      '';
    };

    localNetworkGameTransfers.openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open ports in the firewall for Steam Local Network Game Transfers.
      '';
    };

    gamescopeSession = lib.mkOption {
      description = "Run a GameScope driven Steam session from your display-manager";
      default = {};
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "GameScope Session";
          args = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = ''
              Arguments to be passed to GameScope for the session.
            '';
          };

          env = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = { };
            description = ''
              Environmental variables to be passed to GameScope for the session.
            '';
          };
        };
      };
    };

    extest.enable = lib.mkEnableOption ''
      Load the extest library into Steam, to translate X11 input events to
      uinput events (e.g. for using Steam Input on Wayland)
    '';
  };

  config = lib.mkIf cfg.enable {
    hardware.opengl = { # this fixes the "glXChooseVisual failed" bug, context: https://github.com/NixOS/nixpkgs/issues/47932
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    security.wrappers = lib.mkIf (cfg.gamescopeSession.enable && gamescopeCfg.capSysNice) {
      # needed or steam fails
      bwrap = {
        owner = "root";
        group = "root";
        source = "${pkgs.bubblewrap}/bin/bwrap";
        setuid = true;
      };
    };

    programs.gamescope.enable = lib.mkDefault cfg.gamescopeSession.enable;
    services.displayManager.sessionPackages = lib.mkIf cfg.gamescopeSession.enable [ gamescopeSessionFile ];

    # optionally enable 32bit pulseaudio support if pulseaudio is enabled
    hardware.pulseaudio.support32Bit = config.hardware.pulseaudio.enable;

    hardware.steam-hardware.enable = true;

    environment.systemPackages = [
      cfg.package
      cfg.package.run
    ] ++ lib.optional cfg.gamescopeSession.enable steam-gamescope;

    networking.firewall = lib.mkMerge [
      (lib.mkIf (cfg.remotePlay.openFirewall || cfg.localNetworkGameTransfers.openFirewall) {
        allowedUDPPorts = [ 27036 ]; # Peer discovery
      })

      (lib.mkIf cfg.remotePlay.openFirewall {
        allowedTCPPorts = [ 27036 ];
        allowedUDPPortRanges = [ { from = 27031; to = 27035; } ];
      })

      (lib.mkIf cfg.dedicatedServer.openFirewall {
        allowedTCPPorts = [ 27015 ]; # SRCDS Rcon port
        allowedUDPPorts = [ 27015 ]; # Gameplay traffic
      })

      (lib.mkIf cfg.localNetworkGameTransfers.openFirewall {
        allowedTCPPorts = [ 27040 ]; # Data transfers
      })
    ];
  };

  meta.maintainers = lib.teams.steam;
}
