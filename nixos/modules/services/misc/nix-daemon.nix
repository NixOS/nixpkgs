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

  nixConf =
    assert isNixAtLeast "2.2";
    let

      mkValueString = v:
        if v == null then ""
        else if isInt v then toString v
        else if isBool v then boolToString v
        else if isFloat v then floatToString v
        else if isList v then toString v
        else if isDerivation v then toString v
        else if builtins.isPath v then toString v
        else if isString v then v
        else if isCoercibleToString v then toString v
        else abort "The nix conf value: ${toPretty {} v} can not be encoded";

      mkKeyValue = k: v: "${escape [ "=" ] k} = ${mkValueString v}";

      mkKeyValuePairs = attrs: concatStringsSep "\n" (mapAttrsToList mkKeyValue attrs);

    in
    pkgs.writeTextFile {
      name = "nix.conf";
      text = ''
        # WARNING: this file is generated from the nix.* options in
        # your NixOS configuration, typically
        # /etc/nixos/configuration.nix.  Do not edit it!
        ${mkKeyValuePairs cfg.settings}
        ${cfg.extraOptions}
      '';
      checkPhase =
        if pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform then ''
          echo "Ignoring validation for cross-compilation"
        ''
        else ''
          echo "Validating generated nix.conf"
          ln -s $out ./nix.conf
          set -e
          set +o pipefail
          NIX_CONF_DIR=$PWD \
            ${cfg.package}/bin/nix show-config ${optionalString (isNixAtLeast "2.3pre") "--no-net"} \
              ${optionalString (isNixAtLeast "2.4pre") "--option experimental-features nix-command"} \
            |& sed -e 's/^warning:/error:/' \
            | (! grep '${if cfg.checkConfig then "^error:" else "^error: unknown setting"}')
          set -o pipefail
        '';
    };

  legacyConfMappings = {
    useSandbox = "sandbox";
    buildCores = "cores";
    maxJobs = "max-jobs";
    sandboxPaths = "extra-sandbox-paths";
    binaryCaches = "substituters";
    trustedBinaryCaches = "trusted-substituters";
    binaryCachePublicKeys = "trusted-public-keys";
    autoOptimiseStore = "auto-optimise-store";
    requireSignedBinaryCaches = "require-sigs";
    trustedUsers = "trusted-users";
    allowedUsers = "allowed-users";
    systemFeatures = "system-features";
  };

  semanticConfType = with types;
    let
      confAtom = nullOr
        (oneOf [
          bool
          int
          float
          str
          path
          package
        ]) // {
        description = "Nix config atom (null, bool, int, float, str, path or package)";
      };
    in
    attrsOf (either confAtom (listOf confAtom));

in

{
  imports = [
    (mkRenamedOptionModule [ "nix" "useChroot" ] [ "nix" "useSandbox" ])
    (mkRenamedOptionModule [ "nix" "chrootDirs" ] [ "nix" "sandboxPaths" ])
    (mkRenamedOptionModule [ "nix" "daemonIONiceLevel" ] [ "nix" "daemonIOSchedPriority" ])
    (mkRemovedOptionModule [ "nix" "daemonNiceLevel" ] "Consider nix.daemonCPUSchedPolicy instead.")
  ] ++ mapAttrsToList (oldConf: newConf: mkRenamedOptionModule [ "nix" oldConf ] [ "nix" "settings" newConf ]) legacyConfMappings;

  ###### interface

  options = {

    nix = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable Nix.
          Disabling Nix makes the system hard to modify and the Nix programs and configuration will not be made available by NixOS itself.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.nix;
        defaultText = literalExpression "pkgs.nix";
        description = ''
          This option specifies the Nix package instance to use throughout the system.
        '';
      };

      distributedBuilds = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to distribute builds to the machines listed in
          <option>nix.buildMachines</option>.
        '';
      };

      daemonCPUSchedPolicy = mkOption {
        type = types.enum [ "other" "batch" "idle" ];
        default = "other";
        example = "batch";
        description = ''
          Nix daemon process CPU scheduling policy. This policy propagates to
          build processes. <literal>other</literal> is the default scheduling
          policy for regular tasks. The <literal>batch</literal> policy is
          similar to <literal>other</literal>, but optimised for
          non-interactive tasks. <literal>idle</literal> is for extremely
          low-priority tasks that should only be run when no other task
          requires CPU time.

          Please note that while using the <literal>idle</literal> policy may
          greatly improve responsiveness of a system performing expensive
          builds, it may also slow down and potentially starve crucial
          configuration updates during load.

          <literal>idle</literal> may therefore be a sensible policy for
          systems that experience only intermittent phases of high CPU load,
          such as desktop or portable computers used interactively. Other
          systems should use the <literal>other</literal> or
          <literal>batch</literal> policy instead.

          For more fine-grained resource control, please refer to
          <citerefentry><refentrytitle>systemd.resource-control
          </refentrytitle><manvolnum>5</manvolnum></citerefentry> and adjust
          <option>systemd.services.nix-daemon</option> directly.
      '';
      };

      daemonIOSchedClass = mkOption {
        type = types.enum [ "best-effort" "idle" ];
        default = "best-effort";
        example = "idle";
        description = ''
          Nix daemon process I/O scheduling class. This class propagates to
          build processes. <literal>best-effort</literal> is the default
          class for regular tasks. The <literal>idle</literal> class is for
          extremely low-priority tasks that should only perform I/O when no
          other task does.

          Please note that while using the <literal>idle</literal> scheduling
          class can improve responsiveness of a system performing expensive
          builds, it might also slow down or starve crucial configuration
          updates during load.

          <literal>idle</literal> may therefore be a sensible class for
          systems that experience only intermittent phases of high I/O load,
          such as desktop or portable computers used interactively. Other
          systems should use the <literal>best-effort</literal> class.
      '';
      };

      daemonIOSchedPriority = mkOption {
        type = types.int;
        default = 0;
        example = 1;
        description = ''
          Nix daemon process I/O scheduling priority. This priority propagates
          to build processes. The supported priorities depend on the
          scheduling policy: With idle, priorities are not used in scheduling
          decisions. best-effort supports values in the range 0 (high) to 7
          (low).
        '';
      };

      buildMachines = mkOption {
        type = types.listOf (types.submodule {
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
              default = [ ];
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
                <option>nix.settings.trusted-users</option>.
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
              default = [ ];
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
              default = [ ];
              example = [ "kvm" "big-parallel" ];
              description = ''
                A list of features supported by this builder. The builder will
                be ignored for derivations that require features not in this
                list.
              '';
            };
            publicHostKey = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                The (base64-encoded) public host key of this builder. The field
                is calculated via <command>base64 -w0 /etc/ssh/ssh_host_type_key.pub</command>.
                If null, SSH will use its regular known-hosts file when connecting.
              '';
            };
          };
        });
        default = [ ];
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
        default = { };
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

      nixPath = mkOption {
        type = types.listOf types.str;
        default = [
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

      checkConfig = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If enabled (the default), checks for data type mismatches and that Nix
          can parse the generated nix.conf.
        '';
      };

      registry = mkOption {
        type = types.attrsOf (types.submodule (
          let
            referenceAttrs = with types; attrsOf (oneOf [
              str
              int
              bool
              package
            ]);
          in
          { config, name, ... }:
          {
            options = {
              from = mkOption {
                type = referenceAttrs;
                example = { type = "indirect"; id = "nixpkgs"; };
                description = "The flake reference to be rewritten.";
              };
              to = mkOption {
                type = referenceAttrs;
                example = { type = "github"; owner = "my-org"; repo = "my-nixpkgs"; };
                description = "The flake reference <option>from></option> is rewritten to.";
              };
              flake = mkOption {
                type = types.nullOr types.attrs;
                default = null;
                example = literalExpression "nixpkgs";
                description = ''
                  The flake input <option>from></option> is rewritten to.
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
              to = mkIf (config.flake != null) (mkDefault
                {
                  type = "path";
                  path = config.flake.outPath;
                } // filterAttrs
                (n: _: n == "lastModified" || n == "rev" || n == "revCount" || n == "narHash")
                config.flake);
            };
          }
        ));
        default = { };
        description = ''
          A system-wide flake registry.
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

      settings = mkOption {
        type = types.submodule {
          freeformType = semanticConfType;

          options = {
            max-jobs = mkOption {
              type = types.either types.int (types.enum [ "auto" ]);
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

            auto-optimise-store = mkOption {
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

            cores = mkOption {
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

            sandbox = mkOption {
              type = types.either types.bool (types.enum [ "relaxed" ]);
              default = true;
              description = ''
                If set, Nix will perform builds in a sandboxed environment that it
                will set up automatically for each build. This prevents impurities
                in builds by disallowing access to dependencies outside of the Nix
                store by using network and mount namespaces in a chroot environment.
                This is enabled by default even though it has a possible performance
                impact due to the initial setup time of a sandbox for each build. It
                doesn't affect derivation hashes, so changing this option will not
                trigger a rebuild of packages.
              '';
            };

            extra-sandbox-paths = mkOption {
              type = types.listOf types.str;
              default = [ ];
              example = [ "/dev" "/proc" ];
              description = ''
                Directories from the host filesystem to be included
                in the sandbox.
              '';
            };

            substituters = mkOption {
              type = types.listOf types.str;
              description = ''
                List of binary cache URLs used to obtain pre-built binaries
                of Nix packages.

                By default https://cache.nixos.org/ is added.
              '';
            };

            trusted-substituters = mkOption {
              type = types.listOf types.str;
              default = [ ];
              example = [ "https://hydra.nixos.org/" ];
              description = ''
                List of binary cache URLs that non-root users can use (in
                addition to those specified using
                <option>nix.settings.substituters</option>) by passing
                <literal>--option binary-caches</literal> to Nix commands.
              '';
            };

            require-sigs = mkOption {
              type = types.bool;
              default = true;
              description = ''
                If enabled (the default), Nix will only download binaries from binary caches if
                they are cryptographically signed with any of the keys listed in
                <option>nix.settings.trusted-public-keys</option>. If disabled, signatures are neither
                required nor checked, so it's strongly recommended that you use only
                trustworthy caches and https to prevent man-in-the-middle attacks.
              '';
            };

            trusted-public-keys = mkOption {
              type = types.listOf types.str;
              example = [ "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
              description = ''
                List of public keys used to sign binary caches. If
                <option>nix.settings.trusted-public-keys</option> is enabled,
                then Nix will use a binary from a binary cache if and only
                if it is signed by <emphasis>any</emphasis> of the keys
                listed here. By default, only the key for
                <uri>cache.nixos.org</uri> is included.
              '';
            };

            trusted-users = mkOption {
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

            system-features = mkOption {
              type = types.listOf types.str;
              example = [ "kvm" "big-parallel" "gccarch-skylake" ];
              description = ''
                The set of features supported by the machine. Derivations
                can express dependencies on system features through the
                <literal>requiredSystemFeatures</literal> attribute.

                By default, pseudo-features <literal>nixos-test</literal>, <literal>benchmark</literal>,
                and <literal>big-parallel</literal> used in Nixpkgs are set, <literal>kvm</literal>
                is also included in it is avaliable.
              '';
            };

            allowed-users = mkOption {
              type = types.listOf types.str;
              default = [ "*" ];
              example = [ "@wheel" "@builders" "alice" "bob" ];
              description = ''
                A list of names of users (separated by whitespace) that are
                allowed to connect to the Nix daemon. As with
                <option>nix.settings.trusted-users</option>, you can specify groups by
                prefixing them with <literal>@</literal>. Also, you can
                allow all users by specifying <literal>*</literal>. The
                default is <literal>*</literal>. Note that trusted users are
                always allowed to connect.
              '';
            };
          };
        };
        default = { };
        example = literalExpression ''
          {
            use-sandbox = true;
            show-trace = true;

            system-features = [ "big-parallel" "kvm" "recursive-nix" ];
            sandbox-paths = { "/bin/sh" = "''${pkgs.busybox-sandbox-shell.out}/bin/busybox"; };
          }
        '';
        description = ''
          Configuration for Nix, see
          <link xlink:href="https://nixos.org/manual/nix/stable/#sec-conf-file"/> or
          <citerefentry>
            <refentrytitle>nix.conf</refentrytitle>
            <manvolnum>5</manvolnum>
          </citerefentry> for avalaible options.
          The value declared here will be translated directly to the key-value pairs Nix expects.
          </para>
          <para>
          You can use <command>nix-instantiate --eval --strict '&lt;nixpkgs/nixos&gt;' -A config.nix.settings</command>
          to view the current value. By default it is empty.
          </para>
          <para>
          Nix configurations defined under <option>nix.*</option> will be translated and applied to this
          option. In addition, configuration specified in <option>nix.extraOptions</option> which will be appended
          verbatim to the resulting config file.
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

    environment.etc."nix/nix.conf".source = nixConf;

    environment.etc."nix/registry.json".text = builtins.toJSON {
      version = 2;
      flakes = mapAttrsToList (n: v: { inherit (v) from to exact; }) cfg.registry;
    };

    # List of machines for distributed Nix builds in the format
    # expected by build-remote.pl.
    environment.etc."nix/machines" = mkIf (cfg.buildMachines != [ ]) {
      text =
        concatMapStrings
          (machine:
            (concatStringsSep " " ([
              "${optionalString (machine.sshUser != null) "${machine.sshUser}@"}${machine.hostName}"
              (if machine.system != null then machine.system else if machine.systems != [ ] then concatStringsSep "," machine.systems else "-")
              (if machine.sshKey != null then machine.sshKey else "-")
              (toString machine.maxJobs)
              (toString machine.speedFactor)
              (concatStringsSep "," machine.supportedFeatures)
              (concatStringsSep "," machine.mandatoryFeatures)
            ]
            ++ optional (isNixAtLeast "2.4pre") (if machine.publicHostKey != null then machine.publicHostKey else "-")))
            + "\n"
          )
          cfg.buildMachines;
    };

    assertions =
      let badMachine = m: m.system == null && m.systems == [ ];
      in
      [
        {
          assertion = !(any badMachine cfg.buildMachines);
          message = ''
            At least one system type (via <varname>system</varname> or
              <varname>systems</varname>) must be set for every build machine.
              Invalid machine specifications:
          '' + "      " +
          (concatStringsSep "\n      "
            (map (m: m.hostName)
              (filter (badMachine) cfg.buildMachines)));
        }
      ];

    systemd.packages = [ nixPackage ];

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
            LimitNOFILE = 4096;
          };

        restartTriggers = [ nixConf ];
      };

    # Set up the environment variables for running Nix.
    environment.sessionVariables = cfg.envVars // { NIX_PATH = cfg.nixPath; };

    environment.extraInit =
      ''
        if [ -e "$HOME/.nix-defexpr/channels" ]; then
          export NIX_PATH="$HOME/.nix-defexpr/channels''${NIX_PATH:+:$NIX_PATH}"
        fi
      '';

    nix.nrBuildUsers = mkDefault (max 32 (if cfg.settings.max-jobs == "auto" then 0 else cfg.settings.max-jobs));

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
      {
        trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
        substituters = [ "https://cache.nixos.org/" ];

        system-features = mkDefault (
          [ "nixos-test" "benchmark" "big-parallel" "kvm" ] ++
          optionals (pkgs.hostPlatform ? gcc.arch) (
            # a builder can run code for `gcc.arch` and inferior architectures
            [ "gccarch-${pkgs.hostPlatform.gcc.arch}" ] ++
            map (x: "gccarch-${x}") systems.architectures.inferiors.${pkgs.hostPlatform.gcc.arch}
          )
        );
      }

      (mkIf (!cfg.distributedBuilds) { builders = null; })

      (mkIf (isNixAtLeast "2.3pre") { sandbox-fallback = false; })
    ];

  };

}
