{ config, lib, pkgs, ... }:
let

  inherit (config.security) permissionsWrapperDir;

  isNotNull = v: if v != null then true else false;

  cfg = config.security.permissionsWrappers;

  setcapWrappers = import ./setcap-wrapper-drv.nix {
    inherit config lib pkgs;
  };

  setuidWrappers = import ./setuid-wrapper-drv.nix {
    inherit config lib pkgs;
  };

  ###### Activation script for the setcap wrappers
  configureSetcapWrapper =
    { program
    , capabilities
    , source ? null
    , owner  ? "nobody"
    , group  ? "nogroup"
    , setcap ? false
    }: ''
      cp ${setcapWrappers}/bin/${program}.wrapper ${permissionsWrapperDir}/${program}

      # Prevent races
      chmod 0000 ${permissionsWrapperDir}/${program}
      chown ${owner}.${group} ${permissionsWrapperDir}/${program}

      # Set desired capabilities on the file plus cap_setpcap so
      # the wrapper program can elevate the capabilities set on
      # its file into the Ambient set.
      #
      # Only set the capabilities though if we're being told to
      # do so.
      ${
      if setcap then
        ''
        ${pkgs.libcap.out}/bin/setcap "cap_setpcap,${capabilities}" ${permissionsWrapperDir}/${program}
        ''
      else ""
      }

      # Set the executable bit
      chmod u+rx,g+x,o+x ${permissionsWrapperDir}/${program}
    '';

  ###### Activation script for the setuid wrappers
  configureSetuidWrapper =
    { program
    , source ? null
    , owner  ? "nobody"
    , group  ? "nogroup"
    , setuid ? false
    , setgid ? false
    , permissions ? "u+rx,g+x,o+x"
    }: ''
      cp ${setuidWrappers}/bin/${program}.wrapper ${permissionsWrapperDir}/${program}

      # Prevent races
      chmod 0000 ${permissionsWrapperDir}/${program}
      chown ${owner}.${group} ${permissionsWrapperDir}/${program}

      chmod "u${if setuid then "+" else "-"}s,g${if setgid then "+" else "-"}s,${permissions}" ${permissionsWrapperDir}/${program}
    '';

    mkActivationScript = programsToWrap:
      lib.stringAfter [ "users" ]
        ''
          # Look in the system path and in the default profile for
          # programs to be wrapped.
          PERMISSIONS_WRAPPER_PATH=${config.system.path}/bin:${config.system.path}/sbin

          mkdir -p /run/permissions-wrapper-dirs
          permissionsWrapperDir=$(mktemp --directory --tmpdir=/run/permissions-wrapper-dirs permissions-wrappers.XXXXXXXXXX)
          chmod a+rx $permissionsWrapperDir

          ${programsToWrap}

          if [ -L ${permissionsWrapperDir} ]; then
            # Atomically replace the symlink
            # See https://axialcorps.com/2013/07/03/atomically-replacing-files-and-directories/
            old=$(readlink ${permissionsWrapperDir})
            ln --symbolic --force --no-dereference $permissionsWrapperDir ${permissionsWrapperDir}-tmp
            mv --no-target-directory ${permissionsWrapperDir}-tmp ${permissionsWrapperDir}
            rm --force --recursive $old
          elif [ -d ${permissionsWrapperDir} ]; then
            # Compatibility with old state, just remove the folder and symlink
            rm -f ${permissionsWrapperDir}/*
            # if it happens to be a tmpfs
            ${pkgs.utillinux}/bin/umount ${permissionsWrapperDir} || true
            rm -d ${permissionsWrapperDir}
            ln -d --symbolic $permissionsWrapperDir ${permissionsWrapperDir}
          else
            # For initial setup
            ln --symbolic $permissionsWrapperDir ${permissionsWrapperDir}
          fi
        '';
in
{

  ###### interface

  options = {
    security.permissionsWrappers.setcap = lib.mkOption {
      type    = lib.types.listOf lib.types.attrs;
      default = [];
      example =
        [ { program = "ping";
            source  = "${pkgs.iputils.out}/bin/ping";
            owner   = "nobody";
            group   = "nogroup";
            setcap  = true;
            capabilities = "cap_net_raw+ep";
          }
        ];
      description = ''
        This option sets capabilities on a wrapper program that
        propagates those capabilities down to the wrapped, real
        program.

        The `program` attribute is the name of the program to be
        wrapped. If no `source` attribute is provided, specifying the
        absolute path to the program, then the program will be
        searched for in the path environment variable.

        NOTE: cap_setpcap, which is required for the wrapper program
        to be able to raise caps into the Ambient set is NOT raised to
        the Ambient set so that the real program cannot modify its own
        capabilities!! This may be too restrictive for cases in which
        the real program needs cap_setpcap but it at least leans on
        the side security paranoid vs. too relaxed.

        The attribute `setcap` defaults to false and it will create a
        wrapper program but never set the capability set on it. This
        is done so that you can remove a capability sent entirely from
        a wrapper program without also needing to go change any
        absolute paths that may be directly referencing the wrapper
        program.
      '';
    };

    security.permissionsWrappers.setuid = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [];
      example =
        [ { program = "sendmail";
            source = "/nix/store/.../bin/sendmail";
            owner = "nobody";
            group = "postdrop";
            setuid = false;
            setgid = true;
            permissions = "u+rx,g+x,o+x";
          }
        ];
      description = ''
        This option allows the ownership and permissions on the setuid
        wrappers for specific programs to be overridden from the
        default (setuid root, but not setgid root).
      '';
    };

    security.permissionsWrapperDir = lib.mkOption {
      type        = lib.types.path;
      default     = "/var/permissions-wrappers";
      internal    = true;
      description = ''
        This option defines the path to the permissions wrappers. It
        should not be overriden.
      '';
    };

  };


  ###### implementation
  
  config = {

    # Make sure our setcap-wrapper dir exports to the PATH env
    # variable when initializing the shell
    environment.extraInit = ''
    # The permissions wrappers override other bin directories.
    export PATH="${config.security.permissionsWrapperDir}:$PATH"
    '';

    system.activationScripts.wrapper-dir = ''
      mkdir -p "${config.security.permissionsWrapperDir}"
    '';

    ###### setcap activation script
    system.activationScripts.setcap =
      mkActivationScript (lib.concatMapStrings configureSetcapWrapper (builtins.filter isNotNull cfg.setcap));

    ###### setuid activation script
    system.activationScripts.setuid =
      mkActivationScript (lib.concatMapStrings configureSetuidWrapper (builtins.filter isNotNull cfg.setuid));
  };
}
