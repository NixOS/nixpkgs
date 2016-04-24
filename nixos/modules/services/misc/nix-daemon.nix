{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.nix;

  nix = cfg.package.out;

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
      # If we're using a chroot for builds, then provide /bin/sh in
      # the chroot as a bind-mount to bash. This means we also need to
      # include the entire closure of bash.
      sh = pkgs.stdenv.shell;
      binshDeps = pkgs.writeReferencesToFile sh;
    in
      pkgs.runCommand "nix.conf" {extraOptions = cfg.extraOptions; } ''
        extraPaths=$(for i in $(cat ${binshDeps}); do if test -d $i; then echo $i; fi; done)
        cat > $out <<END
        # WARNING: this file is generated from the nix.* options in
        # your NixOS configuration, typically
        # /etc/nixos/configuration.nix.  Do not edit it!
        build-users-group = nixbld
        build-max-jobs = ${toString (cfg.maxJobs)}
        build-cores = ${toString (cfg.buildCores)}
        build-use-chroot = ${if (builtins.isBool cfg.useChroot) then (if cfg.useChroot then "true" else "false") else cfg.useChroot}
        build-chroot-dirs = ${toString cfg.chrootDirs} /bin/sh=${sh} $(echo $extraPaths)
        binary-caches = ${toString cfg.binaryCaches}
        trusted-binary-caches = ${toString cfg.trustedBinaryCaches}
        binary-cache-public-keys = ${toString cfg.binaryCachePublicKeys}
        ${optionalString cfg.requireSignedBinaryCaches ''
          signed-binary-caches = *
        ''}
        trusted-users = ${toString cfg.trustedUsers}
        allowed-users = ${toString cfg.allowedUsers}
        $extraOptions
        END
      '';

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
        type = types.int;
        default = 1;
        example = 64;
        description = ''
          This option defines the maximum number of jobs that Nix will try
          to build in parallel.  The default is 1.  You should generally
          set it to the total number of logical cores in your system (e.g., 16
          for two CPUs with 4 cores each and hyper-threading).
        '';
      };

      buildCores = mkOption {
        type = types.int;
        default = 1;
        example = 64;
        description = ''
          This option defines the maximum number of concurrent tasks during
          one build. It affects, e.g., -j option for make. The default is 1.
          The special value 0 means that the builder should use all
          available CPU cores in the system. Some builds may become
          non-deterministic with this option; use with care! Packages will
          only be affected if enableParallelBuilding is set for them.
        '';
      };

      useChroot = mkOption {
        type = types.either types.bool (types.enum ["relaxed"]);
        default = false;
        description = "
          If set, Nix will perform builds in a chroot-environment that it
          will set up automatically for each build.  This prevents
          impurities in builds by disallowing access to dependencies
          outside of the Nix store.
        ";
      };

      chrootDirs = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "/dev" "/proc" ];
        description =
          ''
            Directories from the host filesystem to be included
            in the chroot.
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
        example = [
          { hostName = "voila.labs.cs.uu.nl";
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
            supportedFeatures = "kvm";
            mandatoryFeatures = "perf";
          }
        ];
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
        default = [ https://cache.nixos.org/ ];
        description = ''
          List of binary cache URLs used to obtain pre-built binaries
          of Nix packages.
        '';
      };

      trustedBinaryCaches = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ http://hydra.nixos.org/ ];
        description = ''
          List of binary cache URLs that non-root users can use (in
          addition to those specified using
          <option>nix.binaryCaches</option> by passing
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
          [ "/nix/var/nix/profiles/per-user/root/channels/nixos"
            "nixos-config=/etc/nixos/configuration.nix"
            "/nix/var/nix/profiles/per-user/root/channels"
          ];
        description = ''
          The default Nix expression search path, used by the Nix
          evaluator to look up paths enclosed in angle brackets
          (e.g. <literal>&lt;nixpkgs&gt;</literal>).
        '';
      };

    };

  };


  ###### implementation

  config = {

    nix.binaryCachePublicKeys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];

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
      { path = [ nix pkgs.openssl.bin pkgs.utillinux config.programs.ssh.package ]
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

    nix.envVars =
      { NIX_CONF_DIR = "/etc/nix";

        # Enable the copy-from-other-stores substituter, which allows
        # builds to be sped up by copying build results from remote
        # Nix stores.  To do this, mount the remote file system on a
        # subdirectory of /run/nix/remote-stores.
        NIX_OTHER_STORES = "/run/nix/remote-stores/*/nix";
      }

      // optionalAttrs cfg.distributedBuilds {
        NIX_BUILD_HOOK = "${nix}/libexec/nix/build-remote.pl";
        NIX_REMOTE_SYSTEMS = "/etc/nix/machines";
        NIX_CURRENT_LOAD = "/run/nix/current-load";
      };

    # Set up the environment variables for running Nix.
    environment.sessionVariables = cfg.envVars //
      { NIX_PATH = concatStringsSep ":" cfg.nixPath;
      };

    environment.extraInit =
      ''
        # Set up secure multi-user builds: non-root users build through the
        # Nix daemon.
        if [ "$USER" != root -o ! -w /nix/var/nix/db ]; then
            export NIX_REMOTE=daemon
        fi
      '';

    nix.nrBuildUsers = mkDefault (lib.max 10 cfg.maxJobs);

    users.extraUsers = nixbldUsers;

    services.xserver.displayManager.hiddenUsers = map ({ name, ... }: name) nixbldUsers;

    system.activationScripts.nix = stringAfter [ "etc" "users" ]
      ''
        # Nix initialisation.
        mkdir -m 0755 -p \
          /nix/var/nix/gcroots \
          /nix/var/nix/temproots \
          /nix/var/nix/manifests \
          /nix/var/nix/userpool \
          /nix/var/nix/profiles \
          /nix/var/nix/db \
          /nix/var/log/nix/drvs \
          /nix/var/nix/channel-cache
        mkdir -m 1777 -p \
          /nix/var/nix/gcroots/per-user \
          /nix/var/nix/profiles/per-user \
          /nix/var/nix/gcroots/tmp
      '';

  };

}
