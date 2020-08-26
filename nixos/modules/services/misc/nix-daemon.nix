{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.nix;

  nix = cfg.package.out;

  nixVersion = getVersion nix;

  isNix23 = versionAtLeast nixVersion "2.3pre";

  makeNixBuildUser = nr: {
    name  = "nixbld${toString nr}";
    value = {
      description = "Nix build user ${toString nr}";

      /* For consistency with the setgid(2), setuid(2), and setgroups(2)
         calls in `libstore/build.cc', don't add any supplementary group
         here except "nixbld".  */
      uid = builtins.add config.ids.uids.nixbld nr;
      group = "nixbld";
      extraGroups = [ "nixbld" ];
    };
  };

  nixbldUsers = listToAttrs (map makeNixBuildUser (range 1 cfg.nrBuildUsers));

  nixConf =
    assert versionAtLeast nixVersion "2.2";
    pkgs.runCommand "nix.conf" { preferLocalBuild = true; extraOptions = cfg.extraOptions; } (
      ''
        cat > $out <<END
        # WARNING: this file is generated from the nix.* options in
        # your NixOS configuration, typically
        # /etc/nixos/configuration.nix.  Do not edit it!
        build-users-group = nixbld
        max-jobs = ${toString (cfg.maxJobs)}
        cores = ${toString (cfg.buildCores)}
        sandbox = ${if (builtins.isBool cfg.useSandbox) then boolToString cfg.useSandbox else cfg.useSandbox}
        extra-sandbox-paths = ${toString cfg.sandboxPaths}
        substituters = ${toString cfg.binaryCaches}
        trusted-substituters = ${toString cfg.trustedBinaryCaches}
        trusted-public-keys = ${toString cfg.binaryCachePublicKeys}
        auto-optimise-store = ${boolToString cfg.autoOptimiseStore}
        require-sigs = ${if cfg.requireSignedBinaryCaches then "true" else "false"}
        trusted-users = ${toString cfg.trustedUsers}
        allowed-users = ${toString cfg.allowedUsers}
        ${optionalString (!cfg.distributedBuilds) ''
          builders =
        ''}
        system-features = ${toString cfg.systemFeatures}
        ${optionalString isNix23 ''
          sandbox-fallback = false
        ''}
        $extraOptions
        END
      '' + optionalString cfg.checkConfig (
            if pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform then ''
              echo "Ignore nix.checkConfig when cross-compiling"
            '' else ''
              echo "Checking that Nix can read nix.conf..."
              ln -s $out ./nix.conf
              NIX_CONF_DIR=$PWD ${cfg.package}/bin/nix show-config ${optionalString isNix23 "--no-net --option experimental-features nix-command"} >/dev/null
            '')
      );

in

{
  imports = [
    (mkRenamedOptionModule [ "nix" "useChroot" ] [ "nix" "useSandbox" ])
    (mkRenamedOptionModule [ "nix" "chrootDirs" ] [ "nix" "sandboxPaths" ])
  ];

  ###### interface

  options = {

    nix = {

      package = mkOption {
        type = types.package;
        default = pkgs.nix;
        defaultText = "pkgs.nix";
        description = ''
          This option specifies the Nix package instance to use throughout the system.
        '';
      };

      maxJobs = mkOption {
        type = types.either types.int (types.enum ["auto"]);
        default = "auto";
        example = 64;
        description = ''
          This option defines the maximum number of jobs that Nix will try to
          build in parallel. The default is auto, which means it will use all
          available logical cores. It is recommend to set it to the total
          number of logical cores in your system (e.g., 16 for two CPUs with 4
          cores each and hyper-threading).
        '';
      };

      autoOptimiseStore = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
         If set to true, Nix automatically detects files in the store that have
         identical contents, and replaces them with hard links to a single copy.
         This saves disk space. If set to false (the default), you can still run
         nix-store --optimise to get rid of duplicate files.
        '';
      };

      buildCores = mkOption {
        type = types.int;
        default = 0;
        example = 64;
        description = ''
          This option defines the maximum number of concurrent tasks during
          one build. It affects, e.g., -j option for make.
          The special value 0 means that the builder should use all
          available CPU cores in the system. Some builds may become
          non-deterministic with this option; use with care! Packages will
          only be affected if enableParallelBuilding is set for them.
        '';
      };

      useSandbox = mkOption {
        type = types.either types.bool (types.enum ["relaxed"]);
        default = true;
        description = "
          If set, Nix will perform builds in a sandboxed environment that it
          will set up automatically for each build. This prevents impurities
          in builds by disallowing access to dependencies outside of the Nix
          store by using network and mount namespaces in a chroot environment.
          This is enabled by default even though it has a possible performance
          impact due to the initial setup time of a sandbox for each build. It
          doesn't affect derivation hashes, so changing this option will not
          trigger a rebuild of packages.
        ";
      };

      sandboxPaths = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "/dev" "/proc" ];
        description =
          ''
            Directories from the host filesystem to be included
            in the sandbox.
          '';
      };

      extraOptions = mkOption {
        type = types.lines;
        default = "";
        example = ''
          keep-outputs = true
          keep-derivations = true
        '';
        description = "Additional text appended to <filename>nix.conf</filename>.";
      };

      distributedBuilds = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to distribute builds to the machines listed in
          <option>nix.buildMachines</option>.
        '';
      };

      daemonNiceLevel = mkOption {
        type = types.int;
        default = 0;
        description = ''
          Nix daemon process priority. This priority propagates to build processes.
          0 is the default Unix process priority, 19 is the lowest.
        '';
      };

      daemonIONiceLevel = mkOption {
        type = types.int;
        default = 0;
        description = ''
          Nix daemon process I/O priority. This priority propagates to build processes.
          0 is the default Unix process I/O priority, 7 is the lowest.
        '';
      };

      buildMachines = mkOption {
        type = types.listOf (types.submodule ({
          options = {
            hostName = mkOption {
              type = types.str;
              example = "nixbuilder.example.org";
              description = ''
                The hostname of the build machine.
              '';
            };
            system = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "x86_64-linux";
              description = ''
                The system type the build machine can execute derivations on.
                Either this attribute or <varname>systems</varname> must be
                present, where <varname>system</varname> takes precedence if
                both are set.
              '';
            };
            systems = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "x86_64-linux" "aarch64-linux" ];
              description = ''
                The system types the build machine can execute derivations on.
                Either this attribute or <varname>system</varname> must be
                present, where <varname>system</varname> takes precedence if
                both are set.
              '';
            };
            sshUser = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "builder";
              description = ''
                The username to log in as on the remote host. This user must be
                able to log in and run nix commands non-interactively. It must
                also be privileged to build derivations, so must be included in
                <option>nix.trustedUsers</option>.
              '';
            };
            sshKey = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "/root/.ssh/id_buildhost_builduser";
              description = ''
                The path to the SSH private key with which to authenticate on
                the build machine. The private key must not have a passphrase.
                If null, the building user (root on NixOS machines) must have an
                appropriate ssh configuration to log in non-interactively.

                Note that for security reasons, this path must point to a file
                in the local filesystem, *not* to the nix store.
              '';
            };
            maxJobs = mkOption {
              type = types.int;
              default = 1;
              description = ''
                The number of concurrent jobs the build machine supports. The
                build machine will enforce its own limits, but this allows hydra
                to schedule better since there is no work-stealing between build
                machines.
              '';
            };
            speedFactor = mkOption {
              type = types.int;
              default = 1;
              description = ''
                The relative speed of this builder. This is an arbitrary integer
                that indicates the speed of this builder, relative to other
                builders. Higher is faster.
              '';
            };
            mandatoryFeatures = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "big-parallel" ];
              description = ''
                A list of features mandatory for this builder. The builder will
                be ignored for derivations that don't require all features in
                this list. All mandatory features are automatically included in
                <varname>supportedFeatures</varname>.
              '';
            };
            supportedFeatures = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "kvm" "big-parallel" ];
              description = ''
                A list of features supported by this builder. The builder will
                be ignored for derivations that require features not in this
                list.
              '';
            };
          };
        }));
        default = [];
        description = ''
          This option lists the machines to be used if distributed builds are
          enabled (see <option>nix.distributedBuilds</option>).
          Nix will perform derivations on those machines via SSH by copying the
          inputs to the Nix store on the remote machine, starting the build,
          then copying the output back to the local Nix store.
        '';
      };

      # Environment variables for running Nix.
      envVars = mkOption {
        type = types.attrs;
        internal = true;
        default = {};
        description = "Environment variables used by Nix.";
      };

      nrBuildUsers = mkOption {
        type = types.int;
        description = ''
          Number of <literal>nixbld</literal> user accounts created to
          perform secure concurrent builds.  If you receive an error
          message saying that “all build users are currently in use”,
          you should increase this value.
        '';
      };

      readOnlyStore = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If set, NixOS will enforce the immutability of the Nix store
          by making <filename>/nix/store</filename> a read-only bind
          mount.  Nix will automatically make the store writable when
          needed.
        '';
      };

      binaryCaches = mkOption {
        type = types.listOf types.str;
        description = ''
          List of binary cache URLs used to obtain pre-built binaries
          of Nix packages.

          By default https://cache.nixos.org/ is added,
          to override it use <literal>lib.mkForce []</literal>.
        '';
      };

      trustedBinaryCaches = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "https://hydra.nixos.org/" ];
        description = ''
          List of binary cache URLs that non-root users can use (in
          addition to those specified using
          <option>nix.binaryCaches</option>) by passing
          <literal>--option binary-caches</literal> to Nix commands.
        '';
      };

      requireSignedBinaryCaches = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If enabled (the default), Nix will only download binaries from binary caches if
          they are cryptographically signed with any of the keys listed in
          <option>nix.binaryCachePublicKeys</option>. If disabled, signatures are neither
          required nor checked, so it's strongly recommended that you use only
          trustworthy caches and https to prevent man-in-the-middle attacks.
        '';
      };

      binaryCachePublicKeys = mkOption {
        type = types.listOf types.str;
        example = [ "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
        description = ''
          List of public keys used to sign binary caches. If
          <option>nix.requireSignedBinaryCaches</option> is enabled,
          then Nix will use a binary from a binary cache if and only
          if it is signed by <emphasis>any</emphasis> of the keys
          listed here. By default, only the key for
          <uri>cache.nixos.org</uri> is included.
        '';
      };

      trustedUsers = mkOption {
        type = types.listOf types.str;
        default = [ "root" ];
        example = [ "root" "alice" "@wheel" ];
        description = ''
          A list of names of users that have additional rights when
          connecting to the Nix daemon, such as the ability to specify
          additional binary caches, or to import unsigned NARs. You
          can also specify groups by prefixing them with
          <literal>@</literal>; for instance,
          <literal>@wheel</literal> means all users in the wheel
          group.
        '';
      };

      allowedUsers = mkOption {
        type = types.listOf types.str;
        default = [ "*" ];
        example = [ "@wheel" "@builders" "alice" "bob" ];
        description = ''
          A list of names of users (separated by whitespace) that are
          allowed to connect to the Nix daemon. As with
          <option>nix.trustedUsers</option>, you can specify groups by
          prefixing them with <literal>@</literal>. Also, you can
          allow all users by specifying <literal>*</literal>. The
          default is <literal>*</literal>. Note that trusted users are
          always allowed to connect.
        '';
      };

      nixPath = mkOption {
        type = types.listOf types.str;
        default =
          [
            "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
            "nixos-config=/etc/nixos/configuration.nix"
            "/nix/var/nix/profiles/per-user/root/channels"
          ];
        description = ''
          The default Nix expression search path, used by the Nix
          evaluator to look up paths enclosed in angle brackets
          (e.g. <literal>&lt;nixpkgs&gt;</literal>).
        '';
      };

      systemFeatures = mkOption {
        type = types.listOf types.str;
        example = [ "kvm" "big-parallel" "gccarch-skylake" ];
        description = ''
          The supported features of a machine
        '';
      };

      checkConfig = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If enabled (the default), checks that Nix can parse the generated nix.conf.
        '';
      };

      registry = mkOption {
        type = types.attrsOf (types.submodule (
          let
            inputAttrs = types.attrsOf (types.oneOf [types.str types.int types.bool types.package]);
          in
          { config, name, ... }:
          { options = {
              from = mkOption {
                type = inputAttrs;
                example = { type = "indirect"; id = "nixpkgs"; };
                description = "The flake reference to be rewritten.";
              };
              to = mkOption {
                type = inputAttrs;
                example = { type = "github"; owner = "my-org"; repo = "my-nixpkgs"; };
                description = "The flake reference to which <option>from></option> is to be rewritten.";
              };
              flake = mkOption {
                type = types.unspecified;
                default = null;
                example = literalExample "nixpkgs";
                description = ''
                  The flake input to which <option>from></option> is to be rewritten.
                '';
              };
              exact = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether the <option>from</option> reference needs to match exactly. If set,
                  a <option>from</option> reference like <literal>nixpkgs</literal> does not
                  match with a reference like <literal>nixpkgs/nixos-20.03</literal>.
                '';
              };
            };
            config = {
              from = mkDefault { type = "indirect"; id = name; };
              to = mkIf (config.flake != null)
                ({ type = "path";
                   path = config.flake.outPath;
                 } // lib.filterAttrs
                   (n: v: n == "lastModified" || n == "rev" || n == "revCount" || n == "narHash")
                   config.flake);
            };
          }
        ));
        default = {};
        description = ''
          A system-wide flake registry.
        '';
      };

    };

  };


  ###### implementation

  config = {

    assertions = [
      {
        assertion = config.nix.distributedBuilds || config.nix.buildMachines == [];
        message = "You must set `nix.distributedBuilds = true` to use nix.buildMachines";
      }
    ];

    nix.binaryCachePublicKeys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    nix.binaryCaches = [ "https://cache.nixos.org/" ];

    environment.systemPackages =
      [ nix
        pkgs.nix-info
      ]
      ++ optional (config.programs.bash.enableCompletion && !versionAtLeast nixVersion "2.4pre") pkgs.nix-bash-completions;

    environment.etc."nix/nix.conf".source = nixConf;

    environment.etc."nix/registry.json".text = builtins.toJSON {
      version = 2;
      flakes = mapAttrsToList (n: v: { inherit (v) from to exact; }) cfg.registry;
    };

    # List of machines for distributed Nix builds in the format
    # expected by build-remote.pl.
    environment.etc."nix/machines" =
      { enable = cfg.buildMachines != [];
        text =
          concatMapStrings (machine:
            "${if machine.sshUser != null then "${machine.sshUser}@" else ""}${machine.hostName} "
            + (if machine.system != null then machine.system else concatStringsSep "," machine.systems)
            + " ${if machine.sshKey != null then machine.sshKey else "-"} ${toString machine.maxJobs} "
            + toString (machine.speedFactor)
            + " "
            + concatStringsSep "," (machine.mandatoryFeatures ++ machine.supportedFeatures)
            + " "
            + concatStringsSep "," machine.mandatoryFeatures
            + "\n"
          ) cfg.buildMachines;
      };

    systemd.packages = [ nix ];

    systemd.sockets.nix-daemon.wantedBy = [ "sockets.target" ];

    systemd.services.nix-daemon =
      { path = [ nix pkgs.utillinux config.programs.ssh.package ]
          ++ optionals cfg.distributedBuilds [ pkgs.gzip ];

        environment = cfg.envVars
          // { CURL_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt"; }
          // config.networking.proxy.envVars;

        unitConfig.RequiresMountsFor = "/nix/store";

        serviceConfig =
          { Nice = cfg.daemonNiceLevel;
            IOSchedulingPriority = cfg.daemonIONiceLevel;
            LimitNOFILE = 4096;
          };

        restartTriggers = [ nixConf ];
      };

    # Set up the environment variables for running Nix.
    environment.sessionVariables = cfg.envVars //
      { NIX_PATH = cfg.nixPath;
      };

    environment.extraInit =
      ''
        if [ -e "$HOME/.nix-defexpr/channels" ]; then
          export NIX_PATH="$HOME/.nix-defexpr/channels''${NIX_PATH:+:$NIX_PATH}"
        fi
      '';

    nix.nrBuildUsers = mkDefault (lib.max 32 (if cfg.maxJobs == "auto" then 0 else cfg.maxJobs));

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

    nix.systemFeatures = mkDefault (
      [ "nixos-test" "benchmark" "big-parallel" "kvm" ] ++
      optionals (pkgs.stdenv.isx86_64 && pkgs.hostPlatform.platform ? gcc.arch) (
        # a x86_64 builder can run code for `platform.gcc.arch` and minor architectures:
        [ "gccarch-${pkgs.hostPlatform.platform.gcc.arch}" ] ++ {
          sandybridge    = [ "gccarch-westmere" ];
          ivybridge      = [ "gccarch-westmere" "gccarch-sandybridge" ];
          haswell        = [ "gccarch-westmere" "gccarch-sandybridge" "gccarch-ivybridge" ];
          broadwell      = [ "gccarch-westmere" "gccarch-sandybridge" "gccarch-ivybridge" "gccarch-haswell" ];
          skylake        = [ "gccarch-westmere" "gccarch-sandybridge" "gccarch-ivybridge" "gccarch-haswell" "gccarch-broadwell" ];
          skylake-avx512 = [ "gccarch-westmere" "gccarch-sandybridge" "gccarch-ivybridge" "gccarch-haswell" "gccarch-broadwell" "gccarch-skylake" ];
        }.${pkgs.hostPlatform.platform.gcc.arch} or []
      )
    );

  };

}
