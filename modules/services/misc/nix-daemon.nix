{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (config.environment) nix;

in

{

  ###### interface

  options = {

    environment.nix = mkOption {
      default = pkgs.nixUnstable;
      example = pkgs.nixCustomFun /root/nix.tar.gz;
      merge = mergeOneOption;
      description = "
        This option specifies the Nix package instance to use throughout the system.
      ";
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

      extraOptions = mkOption {
        default = "";
        example = "
          gc-keep-outputs = true
          gc-keep-derivations = true
        ";
        description = "
          This option allows to append lines to nix.conf. 
        ";
      };

      distributedBuilds = mkOption {
        default = false;
        description = "
          Whether to distribute builds to the machines listed in
          <option>nix.buildMachines</option>.
        ";
      };

      daemonNiceLevel = mkOption {
        default = 2;
        description = "
          Nix daemon process priority. This priority propagates to build processes.
          0 is the default Unix process priority, 20 is the lowest.
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
        default = "";
        merge = mergeStringOption;
        description = "
          Environment variables used by Nix.
        ";
      };
    };
  };


  ###### implementation

  config = {

    environment.etc =
      [ { # Nix configuration.
          source =
            let
              # Tricky: if we're using a chroot for builds, then we need
              # /bin/sh in the chroot (our own compromise to purity).
              # However, since /bin/sh is a symlink to some path in the
              # Nix store, which furthermore has runtime dependencies on
              # other paths in the store, we need the closure of /bin/sh
              # in `build-chroot-dirs' - otherwise any builder that uses
              # /bin/sh won't work.
              binshDeps = pkgs.writeReferencesToFile config.system.build.binsh;
  
              # Likewise, if chroots are turned on, we need Nix's own
              # closure in the chroot.  Otherwise nix-channel and nix-env
              # won't work because the dependencies of its builders (like
              # coreutils and Perl) aren't visible.  Sigh.
              nixDeps = pkgs.writeReferencesToFile config.environment.nix;
            in 
              pkgs.runCommand "nix.conf" {extraOptions = config.nix.extraOptions; } ''
                extraPaths=$(for i in $(cat ${binshDeps} ${nixDeps}); do if test -d $i; then echo $i; fi; done)
                cat > $out <<END
                # WARNING: this file is generated.
                build-users-group = nixbld
                build-max-jobs = ${toString (config.nix.maxJobs)}
                build-use-chroot = ${if config.nix.useChroot then "true" else "false"}
                build-chroot-dirs = /dev /dev/pts /proc /bin $(echo $extraPaths)
                $extraOptions
                END
              '';
          target = "nix.conf"; # will be symlinked from /nix/etc/nix/nix.conf in activate-configuration.sh.
        }
      ]

      ++ optional config.nix.distributedBuilds
        { # List of machines for distributed Nix builds in the format expected
          # by build-remote.pl.
          source = pkgs.writeText "nix.machines"
            (concatStrings (map (machine:
              "${machine.sshUser}@${machine.hostName} "
              + (if machine ? system then machine.system else concatStringsSep "," machine.systems) 
              + " ${machine.sshKey} ${toString machine.maxJobs} "
              + (if machine ? speedFactor then toString machine.speedFactor else "1" )
              + "\n"
            ) config.nix.buildMachines));
          target = "nix.machines";
        };

    jobs.nixDaemon =
      { startOn = "startup";

        script =
          ''
            export PATH=${if config.nix.distributedBuilds then "${pkgs.openssh}/bin:${pkgs.gzip}/bin:" else ""}${pkgs.openssl}/bin:${nix}/bin:$PATH
            ${config.nix.envVars}
            exec nice -n ${builtins.toString config.nix.daemonNiceLevel} ${nix}/bin/nix-worker --daemon > /dev/null 2>&1
          '';

        extraConfig = 
          ''
            limit nofile 4096 4096
          '';
      };

    environment.shellInit =
      ''
        # Set up the environment variables for running Nix.
        ${config.nix.envVars}
      
        # Set up secure multi-user builds: non-root users build through the
        # Nix daemon.
        if test "$USER" != root; then
            export NIX_REMOTE=daemon
        else
            export NIX_REMOTE=
        fi
      '';

    nix.envVars =
      ''
        export NIX_CONF_DIR=/nix/etc/nix

        # Enable the copy-from-other-stores substituter, which allows builds
        # to be sped up by copying build results from remote Nix stores.  To
        # do this, mount the remote file system on a subdirectory of
        # /var/run/nix/remote-stores.
        export NIX_OTHER_STORES=/var/run/nix/remote-stores/*/nix
      '' 
      + optionalString config.nix.distributedBuilds ''
        export NIX_BUILD_HOOK=${config.environment.nix}/libexec/nix/build-remote.pl
        export NIX_REMOTE_SYSTEMS=/etc/nix.machines
        export NIX_CURRENT_LOAD=/var/run/nix/current-load
      ''
      # !!! These should not be defined here, but in some general proxy configuration module!
      + optionalString (config.nix.proxy != "") ''
        export http_proxy=${config.nix.proxy}
        export https_proxy=${config.nix.proxy}
        export ftp_proxy=${config.nix.proxy}
      '';

  };

}
