{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.nix;

  nixPackage = cfg.package.out;

  isNixAtLeast = versionAtLeast (getVersion nixPackage);

  makeNixBuildUser = nr: {
    name = "nixbld${toString nr}";
    value = {
      description = "Nix build user ${toString nr}";

      /*
        For consistency with the setgid(2), setuid(2), and setgroups(2)
        calls in `libstore/build.cc', don't add any supplementary group
        here except "nixbld".
      */
      uid = builtins.add config.ids.uids.nixbld nr;
      isSystemUser = true;
      group = "nixbld";
      extraGroups = [ "nixbld" ];
    };
  };

  nixbldUsers = listToAttrs (map makeNixBuildUser (range 1 cfg.nrBuildUsers));

in

{
  imports = [
    (mkRenamedOptionModuleWith { sinceRelease = 2205; from = [ "nix" "daemonIONiceLevel" ]; to = [ "nix" "daemonIOSchedPriority" ]; })
    (mkRenamedOptionModuleWith { sinceRelease = 2211; from = [ "nix" "readOnlyStore" ]; to = [ "boot" "readOnlyNixStore" ]; })
    (mkRemovedOptionModule [ "nix" "daemonNiceLevel" ] "Consider nix.daemonCPUSchedPolicy instead.")
  ];

  ###### interface

  options = {

    nix = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable Nix.
          Disabling Nix makes the system hard to modify and the Nix programs and configuration will not be made available by NixOS itself.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.nix;
        defaultText = literalExpression "pkgs.nix";
        description = lib.mdDoc ''
          This option specifies the Nix package instance to use throughout the system.
        '';
      };

      daemonCPUSchedPolicy = mkOption {
        type = types.enum [ "other" "batch" "idle" ];
        default = "other";
        example = "batch";
        description = lib.mdDoc ''
          Nix daemon process CPU scheduling policy. This policy propagates to
          build processes. `other` is the default scheduling
          policy for regular tasks. The `batch` policy is
          similar to `other`, but optimised for
          non-interactive tasks. `idle` is for extremely
          low-priority tasks that should only be run when no other task
          requires CPU time.

          Please note that while using the `idle` policy may
          greatly improve responsiveness of a system performing expensive
          builds, it may also slow down and potentially starve crucial
          configuration updates during load.

          `idle` may therefore be a sensible policy for
          systems that experience only intermittent phases of high CPU load,
          such as desktop or portable computers used interactively. Other
          systems should use the `other` or
          `batch` policy instead.

          For more fine-grained resource control, please refer to
          {manpage}`systemd.resource-control(5)` and adjust
          {option}`systemd.services.nix-daemon` directly.
      '';
      };

      daemonIOSchedClass = mkOption {
        type = types.enum [ "best-effort" "idle" ];
        default = "best-effort";
        example = "idle";
        description = lib.mdDoc ''
          Nix daemon process I/O scheduling class. This class propagates to
          build processes. `best-effort` is the default
          class for regular tasks. The `idle` class is for
          extremely low-priority tasks that should only perform I/O when no
          other task does.

          Please note that while using the `idle` scheduling
          class can improve responsiveness of a system performing expensive
          builds, it might also slow down or starve crucial configuration
          updates during load.

          `idle` may therefore be a sensible class for
          systems that experience only intermittent phases of high I/O load,
          such as desktop or portable computers used interactively. Other
          systems should use the `best-effort` class.
      '';
      };

      daemonIOSchedPriority = mkOption {
        type = types.int;
        default = 4;
        example = 1;
        description = lib.mdDoc ''
          Nix daemon process I/O scheduling priority. This priority propagates
          to build processes. The supported priorities depend on the
          scheduling policy: With idle, priorities are not used in scheduling
          decisions. best-effort supports values in the range 0 (high) to 7
          (low).
        '';
      };

      # Environment variables for running Nix.
      envVars = mkOption {
        type = types.attrs;
        internal = true;
        default = { };
        description = lib.mdDoc "Environment variables used by Nix.";
      };

      nrBuildUsers = mkOption {
        type = types.int;
        description = lib.mdDoc ''
          Number of `nixbld` user accounts created to
          perform secure concurrent builds.  If you receive an error
          message saying that “all build users are currently in use”,
          you should increase this value.
        '';
      };

      nixPath = mkOption {
        type = types.listOf types.str;
        default = [
          "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
          "nixos-config=/etc/nixos/configuration.nix"
          "/nix/var/nix/profiles/per-user/root/channels"
        ];
        description = lib.mdDoc ''
          The default Nix expression search path, used by the Nix
          evaluator to look up paths enclosed in angle brackets
          (e.g. `<nixpkgs>`).
        '';
      };

      registry = mkOption {
        type = types.attrsOf (types.submodule (
          let
            referenceAttrs = with types; attrsOf (oneOf [
              str
              int
              bool
              path
              package
            ]);
          in
          { config, name, ... }:
          {
            options = {
              from = mkOption {
                type = referenceAttrs;
                example = { type = "indirect"; id = "nixpkgs"; };
                description = lib.mdDoc "The flake reference to be rewritten.";
              };
              to = mkOption {
                type = referenceAttrs;
                example = { type = "github"; owner = "my-org"; repo = "my-nixpkgs"; };
                description = lib.mdDoc "The flake reference {option}`from` is rewritten to.";
              };
              flake = mkOption {
                type = types.nullOr types.attrs;
                default = null;
                example = literalExpression "nixpkgs";
                description = lib.mdDoc ''
                  The flake input {option}`from` is rewritten to.
                '';
              };
              exact = mkOption {
                type = types.bool;
                default = true;
                description = lib.mdDoc ''
                  Whether the {option}`from` reference needs to match exactly. If set,
                  a {option}`from` reference like `nixpkgs` does not
                  match with a reference like `nixpkgs/nixos-20.03`.
                '';
              };
            };
            config = {
              from = mkDefault { type = "indirect"; id = name; };
              to = mkIf (config.flake != null) (mkDefault (
                {
                  type = "path";
                  path = config.flake.outPath;
                } // filterAttrs
                  (n: _: n == "lastModified" || n == "rev" || n == "revCount" || n == "narHash")
                  config.flake
              ));
            };
          }
        ));
        default = { };
        description = lib.mdDoc ''
          A system-wide flake registry.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages =
      [
        nixPackage
        pkgs.nix-info
      ]
      ++ optional (config.programs.bash.enableCompletion) pkgs.nix-bash-completions;

    environment.etc."nix/registry.json".text = builtins.toJSON {
      version = 2;
      flakes = mapAttrsToList (n: v: { inherit (v) from to exact; }) cfg.registry;
    };

    systemd.packages = [ nixPackage ];

    # Will only work once https://github.com/NixOS/nix/pull/6285 is merged
    # systemd.tmpfiles.packages = [ nixPackage ];

    # Can be dropped for Nix > https://github.com/NixOS/nix/pull/6285
    systemd.tmpfiles.rules = [
      "d /nix/var/nix/daemon-socket 0755 root root - -"
    ];

    systemd.sockets.nix-daemon.wantedBy = [ "sockets.target" ];

    systemd.services.nix-daemon =
      {
        path = [ nixPackage pkgs.util-linux config.programs.ssh.package ]
          ++ optionals cfg.distributedBuilds [ pkgs.gzip ];

        environment = cfg.envVars
          // { CURL_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt"; }
          // config.networking.proxy.envVars;

        unitConfig.RequiresMountsFor = "/nix/store";

        serviceConfig =
          {
            CPUSchedulingPolicy = cfg.daemonCPUSchedPolicy;
            IOSchedulingClass = cfg.daemonIOSchedClass;
            IOSchedulingPriority = cfg.daemonIOSchedPriority;
            LimitNOFILE = 1048576;
          };

        restartTriggers = [ config.environment.etc."nix/nix.conf".source ];

        # `stopIfChanged = false` changes to switch behavior
        # from   stop -> update units -> start
        #   to   update units -> restart
        #
        # The `stopIfChanged` setting therefore controls a trade-off between a
        # more predictable lifecycle, which runs the correct "version" of
        # the `ExecStop` line, and on the other hand the availability of
        # sockets during the switch, as the effectiveness of the stop operation
        # depends on the socket being stopped as well.
        #
        # As `nix-daemon.service` does not make use of `ExecStop`, we prefer
        # to keep the socket up and available. This is important for machines
        # that run Nix-based services, such as automated build, test, and deploy
        # services, that expect the daemon socket to be available at all times.
        #
        # Notably, the Nix client does not retry on failure to connect to the
        # daemon socket, and the in-process RemoteStore instance will disable
        # itself. This makes retries infeasible even for services that are
        # aware of the issue. Failure to connect can affect not only new client
        # processes, but also new RemoteStore instances in existing processes,
        # as well as existing RemoteStore instances that have not saturated
        # their connection pool.
        #
        # Also note that `stopIfChanged = true` does not kill existing
        # connection handling daemons, as one might wish to happen before a
        # breaking Nix upgrade (which is rare). The daemon forks that handle
        # the individual connections split off into their own sessions, causing
        # them not to be stopped by systemd.
        # If a Nix upgrade does require all existing daemon processes to stop,
        # nix-daemon must do so on its own accord, and only when the new version
        # starts and detects that Nix's persistent state needs an upgrade.
        stopIfChanged = false;

      };

    # Set up the environment variables for running Nix.
    environment.sessionVariables = cfg.envVars // { NIX_PATH = cfg.nixPath; };

    environment.extraInit =
      ''
        if [ -e "$HOME/.nix-defexpr/channels" ]; then
          export NIX_PATH="$HOME/.nix-defexpr/channels''${NIX_PATH:+:$NIX_PATH}"
        fi
      '';

    nix.nrBuildUsers = mkDefault (
      if cfg.settings.auto-allocate-uids or false then 0
      else max 32 (if cfg.settings.max-jobs == "auto" then 0 else cfg.settings.max-jobs)
    );

    users.users = nixbldUsers;

    services.xserver.displayManager.hiddenUsers = attrNames nixbldUsers;

    system.activationScripts.nix = stringAfter [ "etc" "users" ]
      ''
        install -m 0755 -d /nix/var/nix/{gcroots,profiles}/per-user

        # Subscribe the root user to the NixOS channel by default.
        if [ ! -e "/root/.nix-channels" ]; then
            echo "${config.system.defaultChannel} nixos" > "/root/.nix-channels"
        fi
      '';

    # Legacy configuration conversion.
    nix.settings = mkMerge [
      (mkIf (isNixAtLeast "2.3pre") { sandbox-fallback = false; })
    ];

  };

}
