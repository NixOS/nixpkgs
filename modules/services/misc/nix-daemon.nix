{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.nix;

  inherit (config.environment) nix;

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

  nixConf =
    let
      # Tricky: if we're using a chroot for builds, then we need
      # /bin/sh in the chroot (our own compromise to purity).
      # However, since /bin/sh is a symlink to some path in the
      # Nix store, which furthermore has runtime dependencies on
      # other paths in the store, we need the closure of /bin/sh
      # in `build-chroot-dirs' - otherwise any builder that uses
      # /bin/sh won't work.
      binshDeps = pkgs.writeReferencesToFile config.system.build.binsh;
    in
      pkgs.runCommand "nix.conf" {extraOptions = cfg.extraOptions; } ''
        extraPaths=$(for i in $(cat ${binshDeps}); do if test -d $i; then echo $i; fi; done)
        cat > $out <<END
        # WARNING: this file is generated.
        build-users-group = nixbld
        build-max-jobs = ${toString (cfg.maxJobs)}
        build-use-chroot = ${if cfg.useChroot then "true" else "false"}
        build-chroot-dirs = ${toString cfg.chrootDirs} $(echo $extraPaths)
        binary-caches = ${toString cfg.binaryCaches}
        trusted-binary-caches = ${toString cfg.trustedBinaryCaches}
        $extraOptions
        END
      '';

in

{

  ###### interface

  options = {

    environment.nix = mkOption {
      default = pkgs.nix;
      merge = mergeOneOption;
      description = ''
        This option specifies the Nix package instance to use throughout the system.
      '';
    };

    nix = {

      maxJobs = mkOption {
        default = 1;
        example = 2;
        description = "
          This option defines the maximum number of jobs that Nix will try
          to build in parallel.  The default is 1.  You should generally
          set it to the number of CPUs in your system (e.g., 2 on a Athlon
          64 X2).
        ";
      };

      useChroot = mkOption {
        default = false;
        example = true;
        description = "
          If set, Nix will perform builds in a chroot-environment that it
          will set up automatically for each build.  This prevents
          impurities in builds by disallowing access to dependencies
          outside of the Nix store.
        ";
      };

      chrootDirs = mkOption {
        default = [];
        example = [ "/dev" "/proc" ];
        description =
          ''
            Directories from the host filesystem to be included
            in the chroot.
          '';
      };

      extraOptions = mkOption {
        default = "";
        example = "
          gc-keep-outputs = true
          gc-keep-derivations = true
        ";
        description = "Additional text appended to <filename>nix.conf</filename>.";
      };

      distributedBuilds = mkOption {
        default = false;
        description = "
          Whether to distribute builds to the machines listed in
          <option>nix.buildMachines</option>.
          If you know that the <option>buildMachines</option> are not
          always available either use nixos
          <command>nixos-rebuild --no-build-hook</command>
          or consider managing <filename>/etc/nix.machines</filename> manually
          by setting <option>manualNixMachines</option>. Then you can comment
          unavailable buildmachines.
        ";
      };

      manualNixMachines = mkOption {
        default = false;
        description = "
          Whether to manually manage the list of buildmachines used in distributed
          builds in /etc/nix.machines.
        ";
      };

      daemonNiceLevel = mkOption {
        default = 10;
        description = "
          Nix daemon process priority. This priority propagates to build processes.
          0 is the default Unix process priority, 20 is the lowest.
        ";
      };

      daemonIONiceLevel = mkOption {
        default = 7;
        description = "
          Nix daemon process I/O priority. This priority propagates to build processes.
          0 is the default Unix process I/O priority, 7 is the lowest.
        ";
      };

      buildMachines = mkOption {
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
          }
        ];
        description = "
          This option lists the machines to be used if distributed
          builds are enabled (see
          <option>nix.distributedBuilds</option>).  Nix will perform
          derivations on those machines via SSh by copying the inputs to
          the Nix store on the remote machine, starting the build, then
          copying the output back to the local Nix store.  Each element
          of the list should be an attribute set containing the
          machine's host name (<varname>hostname</varname>), the user
          name to be used for the SSH connection
          (<varname>sshUser</varname>), the Nix system type
          (<varname>system</varname>, e.g.,
          <literal>\"i686-linux\"</literal>), the maximum number of jobs
          to be run in parallel on that machine
          (<varname>maxJobs</varname>), and the path to the SSH private
          key to be used to connect (<varname>sshKey</varname>).  The
          SSH private key should not have a passphrase, and the
          corresponding public key should be added to
          <filename>~<replaceable>sshUser</replaceable>/authorized_keys</filename>
          on the remote machine.
        ";
      };

      proxy = mkOption {
        default = "";
        description = "
          This option specifies the proxy to use for fetchurl. The real effect
          is just exporting http_proxy, https_proxy and ftp_proxy with that
          value.
        ";
        example = "http://127.0.0.1:3128";
      };

      # Environment variables for running Nix.  !!! Misnomer - it's
      # actually a shell script.
      envVars = mkOption {
        internal = true;
        default = {};
        type = types.attrs;
        description = "Environment variables used by Nix.";
      };

      nrBuildUsers = mkOption {
        default = 10;
        description = ''
          Number of <literal>nixbld</literal> user accounts created to
          perform secure concurrent builds.  If you receive an error
          message saying that “all build users are currently in use”,
          you should increase this value.
        '';
      };

      readOnlyStore = mkOption {
        default = true;
        description = ''
          If set, NixOS will enforce the immutability of the Nix store
          by making <filename>/nix/store</filename> a read-only bind
          mount.  Nix will automatically make the store writable when
          needed.
        '';
      };

      binaryCaches = mkOption {
        default = [ http://nixos.org/binary-cache ];
        type = types.list types.string;
        description = ''
          List of binary cache URLs used to obtain pre-built binaries
          of Nix packages.
        '';
      };

      trustedBinaryCaches = mkOption {
        default = [ ];
        example = [ http://hydra.nixos.org/ ];
        type = types.list types.string;
        description = ''
          List of binary cache URLs that non-root users can use (in
          addition to those specified using
          <option>nix.binaryCaches</option> by passing
          <literal>--option binary-caches</literal> to Nix commands.
        '';
      };

    };

  };


  ###### implementation

  config = {

    nix.chrootDirs = [ "/dev" "/dev/pts" "/proc" "/bin" ];

    environment.etc."nix/nix.conf".source = nixConf;

    # List of machines for distributed Nix builds in the format
    # expected by build-remote.pl.
    environment.etc."nix.machines" =
      { enable = cfg.distributedBuilds && !cfg.manualNixMachines;
        text =
          concatMapStrings (machine:
            "${machine.sshUser}@${machine.hostName} "
            + (if machine ? system then machine.system else concatStringsSep "," machine.systems)
            + " ${machine.sshKey} ${toString machine.maxJobs} "
            + (if machine ? speedFactor then toString machine.speedFactor else "1" )
            + "\n"
          ) cfg.buildMachines;
      };

    systemd.sockets."nix-daemon" =
      { description = "Nix Daemon Socket";
        wantedBy = [ "sockets.target" ];
        before = [ "multi-user.target" ];
        socketConfig.ListenStream = "/nix/var/nix/daemon-socket/socket";
      };

    systemd.services."nix-daemon" =
      { description = "Nix Daemon";

        path = [ nix pkgs.openssl pkgs.utillinux ]
          ++ optionals cfg.distributedBuilds [ pkgs.openssh pkgs.gzip ];

        environment = cfg.envVars;

        serviceConfig =
          { ExecStart = "@${nix}/bin/nix-daemon nix-daemon --daemon";
            KillMode = "process";
            Nice = cfg.daemonNiceLevel;
            IOSchedulingPriority = cfg.daemonIONiceLevel;
            LimitNOFILE = 4096;
          };

        restartTriggers = [ nixConf ];
      };

    nix.envVars =
      { NIX_CONF_DIR = "/etc/nix";

        # Enable the copy-from-other-stores substituter, which allows builds
        # to be sped up by copying build results from remote Nix stores.  To
        # do this, mount the remote file system on a subdirectory of
        # /var/run/nix/remote-stores.
        NIX_OTHER_STORES = "/var/run/nix/remote-stores/*/nix";
      }

      // optionalAttrs cfg.distributedBuilds {
        NIX_BUILD_HOOK = "${config.environment.nix}/libexec/nix/build-remote.pl";
        NIX_REMOTE_SYSTEMS = "/etc/nix.machines";
        NIX_CURRENT_LOAD = "/var/run/nix/current-load";
      }

      # !!! These should not be defined here, but in some general proxy configuration module!
      // optionalAttrs (cfg.proxy != "") {
        http_proxy = cfg.proxy;
        https_proxy = cfg.proxy;
        ftp_proxy = cfg.proxy;
      };

    environment.shellInit =
      ''
        # Set up the environment variables for running Nix.
        ${concatMapStrings (n: "export ${n}=\"${getAttr n cfg.envVars}\"\n") (attrNames cfg.envVars)}

        # Set up secure multi-user builds: non-root users build through the
        # Nix daemon.
        if test "$USER" != root; then
            export NIX_REMOTE=daemon
        else
            export NIX_REMOTE=
        fi
      '';

    users.extraUsers = map makeNixBuildUser (range 1 cfg.nrBuildUsers);

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
          /nix/var/nix/channel-cache \
          /nix/var/nix/chroots
        mkdir -m 1777 -p \
          /nix/var/nix/gcroots/per-user \
          /nix/var/nix/profiles/per-user \
          /nix/var/nix/gcroots/tmp

        ln -sf /nix/var/nix/profiles /nix/var/nix/gcroots/
        ln -sf /nix/var/nix/manifests /nix/var/nix/gcroots/
      '';

  };

}
