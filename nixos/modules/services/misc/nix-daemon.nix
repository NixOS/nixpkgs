{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.nix;

  nix = cfg.package.out;

  nixVersion = getVersion nix;

  isNix20 = versionAtLeast nixVersion "2.0pre";
  isNix23 = versionAtLeast nixVersion "2.3pre";

  makeNixBuildUser = nr:
    { name = "nixbld${toString nr}";
      description = "Nix build user ${toString nr}";

      /* For consistency with the setgid(2), setuid(2), and setgroups(2)
         calls in `libstore/build.cc', don't add any supplementary group
         here except "nixbld".  */
      uid = builtins.add config.ids.uids.nixbld nr;
      group = "nixbld";
      extraGroups = [ "nixbld" ];
    };

  nixbldUsers = map makeNixBuildUser (range 1 cfg.nrBuildUsers);

  nixConf =
    let
      # In Nix < 2.0, If we're using sandbox for builds, then provide
      # /bin/sh in the sandbox as a bind-mount to bash. This means we
      # also need to include the entire closure of bash. Nix >= 2.0
      # provides a /bin/sh by default.
      sh = pkgs.runtimeShell;
      binshDeps = pkgs.writeReferencesToFile sh;
    in
      pkgs.runCommand "nix.conf" { preferLocalBuild = true; extraOptions = cfg.extraOptions; } (''
        ${optionalString (!isNix20) ''
          extraPaths=$(for i in $(cat ${binshDeps}); do if test -d $i; then echo $i; fi; done)
        ''}
        cat > $out <<END
        # WARNING: this file is generated from the nix.* options in
        # your NixOS configuration, typically
        # /etc/nixos/configuration.nix.  Do not edit it!
        build-users-group = nixbld
        ${if isNix20 then "max-jobs" else "build-max-jobs"} = ${toString (cfg.maxJobs)}
        ${if isNix20 then "cores" else "build-cores"} = ${toString (cfg.buildCores)}
        ${if isNix20 then "sandbox" else "build-use-sandbox"} = ${if (builtins.isBool cfg.useSandbox) then boolToString cfg.useSandbox else cfg.useSandbox}
        ${if isNix20 then "extra-sandbox-paths" else "build-sandbox-paths"} = ${toString cfg.sandboxPaths} ${optionalString (!isNix20) "/bin/sh=${sh} $(echo $extraPaths)"}
        ${if isNix20 then "substituters" else "binary-caches"} = ${toString cfg.binaryCaches}
        ${if isNix20 then "trusted-substituters" else "trusted-binary-caches"} = ${toString cfg.trustedBinaryCaches}
        ${if isNix20 then "trusted-public-keys" else "binary-cache-public-keys"} = ${toString cfg.binaryCachePublicKeys}
        auto-optimise-store = ${boolToString cfg.autoOptimiseStore}
        ${if isNix20 then ''
          require-sigs = ${if cfg.requireSignedBinaryCaches then "true" else "false"}
        '' else ''
          signed-binary-caches = ${if cfg.requireSignedBinaryCaches then "*" else ""}
        ''}
        trusted-users = ${toString cfg.trustedUsers}
        allowed-users = ${toString cfg.allowedUsers}
        ${optionalString (isNix20 && !cfg.distributedBuilds) ''
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
        default = 1;
        example = 64;
        description = ''
          This option defines the maximum number of jobs that Nix will try
          to build in parallel.  The default is 1.  You should generally
          set it to the total number of logical cores in your system (e.g., 16
          for two CPUs with 4 cores each and hyper-threading).
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
          gc-keep-outputs = true
          gc-keep-derivations = true
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
        type = types.listOf types.attrs;
        default = [];
        example = literalExample ''
          [ { hostName = "voila.labs.cs.uu.nl";
              sshUser = "nix";
              sshKey = "/root/.ssh/id_buildfarm";
              system = "powerpc-darwin";
              maxJobs = 1;
            }
            { hostName = "linux64.example.org";
              sshUser = "buildfarm";
              sshKey = "/root/.ssh/id_buildfarm";
              system = "x86_64-linux";
              maxJobs = 2;
              speedFactor = 2;
              supportedFeatures = [ "kvm" ];
              mandatoryFeatures = [ "perf" ];
            }
          ]
        '';
        description = ''
          This option lists the machines to be used if distributed
          builds are enabled (see
          <option>nix.distributedBuilds</option>).  Nix will perform
          derivations on those machines via SSH by copying the inputs
          to the Nix store on the remote machine, starting the build,
          then copying the output back to the local Nix store.  Each
          element of the list should be an attribute set containing
          the machine's host name (<varname>hostname</varname>), the
          user name to be used for the SSH connection
          (<varname>sshUser</varname>), the Nix system type
          (<varname>system</varname>, e.g.,
          <literal>"i686-linux"</literal>), the maximum number of
          jobs to be run in parallel on that machine
          (<varname>maxJobs</varname>), the path to the SSH private
          key to be used to connect (<varname>sshKey</varname>), a
          list of supported features of the machine
          (<varname>supportedFeatures</varname>) and a list of
          mandatory features of the machine
          (<varname>mandatoryFeatures</varname>). The SSH private key
          should not have a passphrase, and the corresponding public
          key should be added to
          <filename>~<replaceable>sshUser</replaceable>/authorized_keys</filename>
          on the remote machine.
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
        example = [ http://hydra.nixos.org/ ];
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
    };

  };


  ###### implementation

  config = {

    nix.binaryCachePublicKeys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    nix.binaryCaches = [ "https://cache.nixos.org/" ];

    environment.etc."nix/nix.conf".source = nixConf;

    # List of machines for distributed Nix builds in the format
    # expected by build-remote.pl.
    environment.etc."nix/machines" =
      { enable = cfg.buildMachines != [];
        text =
          concatMapStrings (machine:
            "${if machine ? sshUser then "${machine.sshUser}@" else ""}${machine.hostName} "
            + machine.system or (concatStringsSep "," machine.systems)
            + " ${machine.sshKey or "-"} ${toString machine.maxJobs or 1} "
            + toString (machine.speedFactor or 1)
            + " "
            + concatStringsSep "," (machine.mandatoryFeatures or [] ++ machine.supportedFeatures or [])
            + " "
            + concatStringsSep "," machine.mandatoryFeatures or []
            + "\n"
          ) cfg.buildMachines;
      };

    systemd.packages = [ nix ];

    systemd.sockets.nix-daemon.wantedBy = [ "sockets.target" ];

    systemd.services.nix-daemon =
      { path = [ nix pkgs.utillinux config.programs.ssh.package ]
          ++ optionals cfg.distributedBuilds [ pkgs.gzip ]
          ++ optionals (!isNix20) [ pkgs.openssl.bin ];

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

    nix.envVars =
      optionalAttrs (!isNix20) {
        NIX_CONF_DIR = "/etc/nix";

        # Enable the copy-from-other-stores substituter, which allows
        # builds to be sped up by copying build results from remote
        # Nix stores.  To do this, mount the remote file system on a
        # subdirectory of /run/nix/remote-stores.
        NIX_OTHER_STORES = "/run/nix/remote-stores/*/nix";
      }

      // optionalAttrs (cfg.distributedBuilds && !isNix20) {
        NIX_BUILD_HOOK = "${nix}/libexec/nix/build-remote.pl";
      };

    # Set up the environment variables for running Nix.
    environment.sessionVariables = cfg.envVars //
      { NIX_PATH = cfg.nixPath;
      };

    environment.extraInit = optionalString (!isNix20)
      ''
        # Set up secure multi-user builds: non-root users build through the
        # Nix daemon.
        if [ "$USER" != root -o ! -w /nix/var/nix/db ]; then
            export NIX_REMOTE=daemon
        fi
      '' + ''
        if [ -e "$HOME/.nix-defexpr/channels" ]; then
          export NIX_PATH="$HOME/.nix-defexpr/channels''${NIX_PATH:+:$NIX_PATH}"
        fi
      '';

    nix.nrBuildUsers = mkDefault (lib.max 32 (if cfg.maxJobs == "auto" then 0 else cfg.maxJobs));

    users.users = nixbldUsers;

    services.xserver.displayManager.hiddenUsers = map ({ name, ... }: name) nixbldUsers;

    system.activationScripts.nix = stringAfter [ "etc" "users" ]
      ''
        # Create directories in /nix.
        ${nix}/bin/nix ping-store --no-net

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
