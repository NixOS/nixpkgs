{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.guix;

  package = cfg.package.override { inherit (cfg) stateDir storeDir; };

  guixBuildUser = id: {
    name = "guixbuilder${toString id}";
    group = cfg.group;
    extraGroups = [ cfg.group ];
    createHome = false;
    description = "Guix build user ${toString id}";
    isSystemUser = true;
  };

  guixBuildUsers =
    numberOfUsers:
    builtins.listToAttrs (
      map (user: {
        name = user.name;
        value = user;
      }) (builtins.genList guixBuildUser numberOfUsers)
    );

  # A set of Guix user profiles to be linked at activation. All of these should
  # be default profiles managed by Guix CLI and the profiles are located in
  # `${cfg.stateDir}/profiles/per-user/$USER/$PROFILE`.
  guixUserProfiles = {
    # The default Guix profile managed by `guix pull`. Take note this should be
    # the profile with the most precedence in `PATH` env to let users use their
    # updated versions of `guix` CLI.
    "current-guix" = "\${XDG_CONFIG_HOME}/guix/current";

    # The default Guix home profile. This profile contains more than exports
    # such as an activation script at `$GUIX_HOME_PROFILE/activate`.
    "guix-home" = "$HOME/.guix-home/profile";

    # The default Guix profile similar to $HOME/.nix-profile from Nix.
    "guix-profile" = "$HOME/.guix-profile";
  };

  # All of the Guix profiles to be used.
  guixProfiles = lib.attrValues guixUserProfiles;

  serviceEnv = {
    GUIX_LOCPATH = "${cfg.stateDir}/guix/profiles/per-user/root/guix-profile/lib/locale";
    LC_ALL = "C.UTF-8";
  };

  # Currently, this is just done the lazy way with the official Guix script. A
  # more "formal" way would be creating our own Guix script to handle and
  # generate the ACL file ourselves.
  aclFile = pkgs.runCommandLocal "guix-acl" { } ''
    export GUIX_CONFIGURATION_DIRECTORY=./
    for official_server_keys in ${lib.concatStringsSep " " cfg.substituters.authorizedKeys}; do
      ${lib.getExe' cfg.package "guix"} archive --authorize < "$official_server_keys"
    done
    install -Dm0600 ./acl "$out"
  '';
in
{
  meta.maintainers = with lib.maintainers; [ foo-dogsquared ];

  options.services.guix = with lib; {
    enable = mkEnableOption "Guix build daemon service";

    group = mkOption {
      type = types.str;
      default = "guixbuild";
      example = "guixbuild";
      description = ''
        The group of the Guix build user pool.
      '';
    };

    nrBuildUsers = mkOption {
      type = types.ints.unsigned;
      description = ''
        Number of Guix build users to be used in the build pool.
      '';
      default = 10;
      example = 20;
    };

    extraArgs = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [
        "--max-jobs=4"
        "--debug"
      ];
      description = ''
        Extra flags to pass to the Guix daemon service.
      '';
    };

    package = mkPackageOption pkgs "guix" {
      extraDescription = ''
        It should contain {command}`guix-daemon` and {command}`guix`
        executable.
      '';
    };

    storeDir = mkOption {
      type = types.path;
      default = "/gnu/store";
      description = ''
        The store directory where the Guix service will serve to/from. Take
        note Guix cannot take advantage of substitutes if you set it something
        other than {file}`/gnu/store` since most of the cached builds are
        assumed to be in there.

        ::: {.warning}
        This will also recompile all packages because the normal cache no
        longer applies.
        :::
      '';
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var";
      description = ''
        The state directory where Guix service will store its data such as its
        user-specific profiles, cache, and state files.

        ::: {.warning}
        Changing it to something other than the default will rebuild the
        package.
        :::
      '';
      example = "/gnu/var";
    };

    substituters = {
      urls = lib.mkOption {
        type = with lib.types; listOf str;
        default = [
          "https://ci.guix.gnu.org"
          "https://bordeaux.guix.gnu.org"
          "https://berlin.guix.gnu.org"
        ];
        example = lib.literalExpression ''
          options.services.guix.substituters.urls.default ++ [
            "https://guix.example.com"
            "https://guix.example.org"
          ]
        '';
        description = ''
          A list of substitute servers' URLs for the Guix daemon to download
          substitutes from.
        '';
      };

      authorizedKeys = lib.mkOption {
        type = with lib.types; listOf path;
        default = [
          "${cfg.package}/share/guix/ci.guix.gnu.org.pub"
          "${cfg.package}/share/guix/bordeaux.guix.gnu.org.pub"
          "${cfg.package}/share/guix/berlin.guix.gnu.org.pub"
        ];
        defaultText = ''
          The packaged signing keys from {option}`services.guix.package`.
        '';
        example = lib.literalExpression ''
          options.services.guix.substituters.authorizedKeys.default ++ [
            (builtins.fetchurl {
              url = "https://guix.example.com/signing-key.pub";
            })

            (builtins.fetchurl {
              url = "https://guix.example.org/static/signing-key.pub";
            })
          ]
        '';
        description = ''
          A list of signing keys for each substitute server to be authorized as
          a source of substitutes. Without this, the listed substitute servers
          from {option}`services.guix.substituters.urls` would be ignored [with
          some
          exceptions](https://guix.gnu.org/manual/en/html_node/Substitute-Authentication.html).
        '';
      };
    };

    publish = {
      enable = mkEnableOption "substitute server for your Guix store directory";

      generateKeyPair = mkOption {
        type = types.bool;
        description = ''
          Whether to generate signing keys in {file}`/etc/guix` which are
          required to initialize a substitute server. Otherwise,
          `--public-key=$FILE` and `--private-key=$FILE` can be passed in
          {option}`services.guix.publish.extraArgs`.
        '';
        default = true;
        example = false;
      };

      port = mkOption {
        type = types.port;
        default = 8181;
        example = 8200;
        description = ''
          Port of the substitute server to listen on.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "guix-publish";
        description = ''
          Name of the user to change once the server is up.
        '';
      };

      extraArgs = mkOption {
        type = with types; listOf str;
        description = ''
          Extra flags to pass to the substitute server.
        '';
        default = [ ];
        example = [
          "--compression=zstd:6"
          "--discover=no"
        ];
      };
    };

    gc = {
      enable = mkEnableOption "automatic garbage collection service for Guix";

      extraArgs = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = ''
          List of arguments to be passed to {command}`guix gc`.

          When given no option, it will try to collect all garbage which is
          often inconvenient so it is recommended to set [some
          options](https://guix.gnu.org/en/manual/en/html_node/Invoking-guix-gc.html).
        '';
        example = [
          "--delete-generations=1m"
          "--free-space=10G"
          "--optimize"
        ];
      };

      dates = lib.mkOption {
        type = types.str;
        default = "03:15";
        example = "weekly";
        description = ''
          How often the garbage collection occurs. This takes the time format
          from {manpage}`systemd.time(7)`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ package ];

        users.users = guixBuildUsers cfg.nrBuildUsers;
        users.groups.${cfg.group} = { };

        # Guix uses Avahi (through guile-avahi) both for the auto-discovering and
        # advertising substitute servers in the local network.
        services.avahi.enable = lib.mkDefault true;
        services.avahi.publish.enable = lib.mkDefault true;
        services.avahi.publish.userServices = lib.mkDefault true;

        # It's similar to Nix daemon so there's no question whether or not this
        # should be sandboxed.
        systemd.services.guix-daemon = {
          environment = serviceEnv // config.networking.proxy.envVars;
          script = ''
            exec ${lib.getExe' package "guix-daemon"} \
              --build-users-group=${cfg.group} \
              ${
                lib.optionalString (
                  cfg.substituters.urls != [ ]
                ) "--substitute-urls='${lib.concatStringsSep " " cfg.substituters.urls}'"
              } \
              ${lib.escapeShellArgs cfg.extraArgs}
          '';
          serviceConfig = {
            OOMPolicy = "continue";
            RemainAfterExit = "yes";
            Restart = "always";
            TasksMax = 8192;
          };
          unitConfig.RequiresMountsFor = [
            cfg.storeDir
            cfg.stateDir
          ];
          wantedBy = [ "multi-user.target" ];
        };

        # This is based from Nix daemon socket unit from upstream Nix package.
        # Guix build daemon has support for systemd-style socket activation.
        systemd.sockets.guix-daemon = {
          description = "Guix daemon socket";
          before = [ "multi-user.target" ];
          listenStreams = [ "${cfg.stateDir}/guix/daemon-socket/socket" ];
          unitConfig.RequiresMountsFor = [
            cfg.storeDir
            cfg.stateDir
          ];
          wantedBy = [ "sockets.target" ];
        };

        systemd.mounts = [
          {
            description = "Guix read-only store directory";
            before = [ "guix-daemon.service" ];
            what = cfg.storeDir;
            where = cfg.storeDir;
            type = "none";
            options = "bind,ro";

            unitConfig.DefaultDependencies = false;
            wantedBy = [ "guix-daemon.service" ];
          }
        ];

        # Make transferring files from one store to another easier with the usual
        # case being of most substitutes from the official Guix CI instance.
        environment.etc."guix/acl".source = aclFile;

        # Link the usual Guix profiles to the home directory. This is useful in
        # ephemeral setups where only certain part of the filesystem is
        # persistent (e.g., "Erase my darlings"-type of setup).
        system.userActivationScripts.guix-activate-user-profiles.text =
          let
            guixProfile = profile: "${cfg.stateDir}/guix/profiles/per-user/\${USER}/${profile}";
            linkProfile =
              profile: location:
              let
                userProfile = guixProfile profile;
              in
              ''
                [ -d "${userProfile}" ] && ln -sfn "${userProfile}" "${location}"
              '';
            linkProfileToPath =
              acc: profile: location:
              acc + (linkProfile profile location);

            # This should contain export-only Guix user profiles. The rest of it is
            # handled manually in the activation script.
            guixUserProfiles' = lib.attrsets.removeAttrs guixUserProfiles [ "guix-home" ];

            linkExportsScript = lib.foldlAttrs linkProfileToPath "" guixUserProfiles';
          in
          ''
            # Don't export this please! It is only expected to be used for this
            # activation script and nothing else.
            XDG_CONFIG_HOME=''${XDG_CONFIG_HOME:-$HOME/.config}

            # Linking the usual Guix profiles into the home directory.
            ${linkExportsScript}

            # Activate all of the default Guix non-exports profiles manually.
            ${linkProfile "guix-home" "$HOME/.guix-home"}
            [ -L "$HOME/.guix-home" ] && "$HOME/.guix-home/activate"
          '';

        # GUIX_LOCPATH is basically LOCPATH but for Guix libc which in turn used by
        # virtually every Guix-built packages. This is so that Guix-installed
        # applications wouldn't use incompatible locale data and not touch its host
        # system.
        environment.sessionVariables.GUIX_LOCPATH = lib.makeSearchPath "lib/locale" guixProfiles;

        # What Guix profiles export is very similar to Nix profiles so it is
        # acceptable to list it here. Also, it is more likely that the user would
        # want to use packages explicitly installed from Guix so we're putting it
        # first.
        environment.profiles = lib.mkBefore guixProfiles;
      }

      (lib.mkIf cfg.publish.enable {
        systemd.services.guix-publish = {
          description = "Guix remote store";
          environment = serviceEnv;

          # Mounts will be required by the daemon service anyways so there's no
          # need add RequiresMountsFor= or something similar.
          requires = [ "guix-daemon.service" ];
          after = [ "guix-daemon.service" ];
          partOf = [ "guix-daemon.service" ];

          preStart = lib.mkIf cfg.publish.generateKeyPair ''
            # Generate the keypair if it's missing.
            [ -f "/etc/guix/signing-key.sec" ] && [ -f "/etc/guix/signing-key.pub" ] || \
              ${lib.getExe' package "guix"} archive --generate-key || {
                rm /etc/guix/signing-key.*;
                ${lib.getExe' package "guix"} archive --generate-key;
              }
          '';
          script = ''
            exec ${lib.getExe' package "guix"} publish \
              --user=${cfg.publish.user} --port=${builtins.toString cfg.publish.port} \
              ${lib.escapeShellArgs cfg.publish.extraArgs}
          '';

          serviceConfig = {
            Restart = "always";
            RestartSec = 10;

            ProtectClock = true;
            ProtectHostname = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectControlGroups = true;
            SystemCallFilter = [
              "@system-service"
              "@debug"
              "@setuid"
            ];

            RestrictNamespaces = true;
            RestrictAddressFamilies = [
              "AF_UNIX"
              "AF_INET"
              "AF_INET6"
            ];

            # While the permissions can be set, it is assumed to be taken by Guix
            # daemon service which it has already done the setup.
            ConfigurationDirectory = "guix";

            AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
            CapabilityBoundingSet = [
              "CAP_NET_BIND_SERVICE"
              "CAP_SETUID"
              "CAP_SETGID"
            ];
          };
          wantedBy = [ "multi-user.target" ];
        };

        users.users.guix-publish = lib.mkIf (cfg.publish.user == "guix-publish") {
          description = "Guix publish user";
          group = config.users.groups.guix-publish.name;
          isSystemUser = true;
        };
        users.groups.guix-publish = { };
      })

      (lib.mkIf cfg.gc.enable {
        # This service should be handled by root to collect all garbage by all
        # users.
        systemd.services.guix-gc = {
          description = "Guix garbage collection";
          startAt = cfg.gc.dates;
          script = ''
            exec ${lib.getExe' package "guix"} gc ${lib.escapeShellArgs cfg.gc.extraArgs}
          '';
          serviceConfig = {
            Type = "oneshot";
            PrivateDevices = true;
            PrivateNetwork = true;
            ProtectControlGroups = true;
            ProtectHostname = true;
            ProtectKernelTunables = true;
            SystemCallFilter = [
              "@default"
              "@file-system"
              "@basic-io"
              "@system-service"
            ];
          };
        };

        systemd.timers.guix-gc.timerConfig.Persistent = true;
      })
    ]
  );
}
