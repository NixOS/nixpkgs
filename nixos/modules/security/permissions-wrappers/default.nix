{ config, lib, pkgs, ... }:
let

  inherit (config.security) permissionsWrapperDir;

  cfg = config.security.permissionsWrappers;

  setcapWrappers = import ./setcap-wrapper-drv.nix { };
  setuidWrappers = import ./setuid-wrapper-drv.nix { };

  ###### Activation script for the setcap wrappers
  configureSetcapWrapper =
    { program
    , capabilities
    , source ? null
    , owner  ? "nobody"
    , group  ? "nogroup"
    , setcap ? false
    }:
    ''
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
  makeSetuidWrapper =
    { program
    , source ? null
    , owner  ? "nobody"
    , group  ? "nogroup"
    , setuid ? false
    , setgid ? false
    , permissions ? "u+rx,g+x,o+x"
    }:

    ''
      cp ${setuidWrappers}/bin/${program}.wrapper ${permissionsWrapperDir}/${program}

      # Prevent races
      chmod 0000 ${permissionsWrapperDir}/${program}
      chown ${owner}.${group} ${permissionsWrapperDir}/${program}

      chmod "u${if setuid then "+" else "-"}s,g${if setgid then "+" else "-"}s,${permissions}" ${permissionsWrapperDir}/${program}
    '';
in
{

  ###### interface

  options = {
    security.permissionsWrappers.setcap = mkOption {
      type    = types.listOf types.attrs;
      default = [];
      example =
        [ { program = "ping";
            source  = "${pkgs.iputils.out}/bin/ping"
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

    security.permissionsWrappers.setuid = mkOption {
      type = types.listOf types.attrs;
      default = [];
      example =
        [ { program = "sendmail";
            source = "${pkgs.sendmail.bin}/bin/sendmail";
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

    security.permissionsWrapperDir = mkOption {
      type        = types.path;
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

    ###### setcap activation script
    system.activationScripts.setcap =
      stringAfter [ "users" ]
        ''
          # Look in the system path and in the default profile for
          # programs to be wrapped.
          PERMISSIONS_WRAPPER_PATH=${config.system.path}/bin:${config.system.path}/sbin

          # When a program is removed from the security.permissionsWrappers.setcap
          # list we have to remove all of the previous program wrappers
          # and re-build them minus the wrapper for the program removed,
          # hence the rm here in the activation script.

          rm -f ${permissionsWrapperDir}/*

          # Concatenate the generated shell slices to configure
          # wrappers for each program needing specialized capabilities.

          ${concatMapStrings configureSetcapWrapper cfg.setcap}
        '';

    ###### setuid activation script
    system.activationScripts.setuid =
      stringAfter [ "users" ]
        ''
          # Look in the system path and in the default profile for
          # programs to be wrapped.
          PERMISSIONS_WRAPPER_PATH=${config.system.path}/bin:${config.system.path}/sbin

          # When a program is removed from the security.permissionsWrappers.setcap
          # list we have to remove all of the previous program wrappers
          # and re-build them minus the wrapper for the program removed,
          # hence the rm here in the activation script.

          rm -f ${permissionsWrapperDir}/*

          # Concatenate the generated shell slices to configure
          # wrappers for each program needing specialized capabilities.

          ${concatMapStrings configureSetuidWrapper cfg.setuid}
        '';

  };
}
