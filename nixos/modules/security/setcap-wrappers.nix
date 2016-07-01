{ config, lib, pkgs, ... }:

with lib; with pkgs;

let

  inherit (config.security) setcapWrapperDir;

  cfg = config.security.setcapCapabilities;

  # Produce a shell-code splice intended to be stitched into one of
  # the build or install phases within the `setcapWrapper` derivation.
  mkSetcapWrapper = { program, source ? null, ...}:
    ''
      if ! source=${if source != null then source else "$(readlink -f $(PATH=$SETCAP_PATH type -tP ${program}))"}; then
          # If we can't find the program, fall back to the
          # system profile.
          source=/nix/var/nix/profiles/default/bin/${program}
      fi

      gcc -Wall -O2 -DSOURCE_PROG=\"$source\" -DWRAPPER_DIR=\"${setcapWrapperDir}\" \
          -lcap-ng -lcap ${./setcap-wrapper.c} -o $out/bin/${program}.wrapper
    '';

  setcapWrappers = 

    # This is only useful for Linux platforms and a kernel version of
    # 4.3 or greater
    assert pkgs.stdenv.isLinux;
    assert versionAtLeast (getVersion config.boot.kernelPackages.kernel) "4.3";

    pkgs.stdenv.mkDerivation {
      name         = "setcap-wrapper";
      unpackPhase  = "true";
      buildInputs  = [ linuxHeaders_4_4 libcap libcap_ng ];
      installPhase = ''
        mkdir -p $out/bin

        # Concat together all of our shell splices to compile
        # binary wrapper programs for all configured setcap programs.
        ${concatMapStrings mkSetcapWrapper cfg}
      '';
    };
in
{
  options = {
    security.setcapCapabilities = mkOption {
      type    = types.listOf types.attrs;
      default = [];
      example =
        [ { program = "sendmail";
            source  = "${pkgs.sendmail.bin}/bin/sendmail";
            owner   = "nobody";
            group   = "postdrop";
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

    security.setcapWrapperDir = mkOption {
      type        = types.path;
      default     = "/var/setcap-wrappers";
      internal    = true;
      description = ''
        This option defines the path to the setcap wrappers. It
        should generally not be overriden.
      '';
    };

  };

  config = {

    # Make sure our setcap-wrapper dir exports to the PATH env
    # variable when initializing the shell
    environment.extraInit = ''
    # The setcap wrappers override other bin directories.
    export PATH="${config.security.setcapWrapperDir}:$PATH"
    '';

    system.activationScripts.setcap =
      let
        setcapPrograms = cfg;
        configureSetcapWrapper =
          { program
          , capabilities
          , source ? null
          , owner  ? "nobody"
          , group  ? "nogroup"
          , setcap ? false
          }:
          ''
            mkdir -p ${setcapWrapperDir}

            cp ${setcapWrappers}/bin/${program}.wrapper ${setcapWrapperDir}/${program}

            # Prevent races
            chmod 0000 ${setcapWrapperDir}/${program}
            chown ${owner}.${group} ${setcapWrapperDir}/${program}

            # Set desired capabilities on the file plus cap_setpcap so
            # the wrapper program can elevate the capabilities set on
            # its file into the Ambient set.
            #
            # Only set the capabilities though if we're being told to
            # do so.
            ${
            if setcap then
              ''
              ${libcap.out}/bin/setcap "cap_setpcap,${capabilities}" ${setcapWrapperDir}/${program}
              ''
            else ""
            }

            # Set the executable bit
            chmod u+rx,g+x,o+x ${setcapWrapperDir}/${program}
          '';

      in stringAfter [ "users" ]
        ''
          # Look in the system path and in the default profile for
          # programs to be wrapped.
          SETCAP_PATH=${config.system.path}/bin:${config.system.path}/sbin

          # When a program is removed from the security.setcapCapabilities
          # list we have to remove all of the previous program wrappers
          # and re-build them minus the wrapper for the program removed,
          # hence the rm here in the activation script.

          rm -f ${setcapWrapperDir}/*

          # Concatenate the generated shell slices to configure
          # wrappers for each program needing specialized capabilities.

          ${concatMapStrings configureSetcapWrapper setcapPrograms}
        '';
  };
}
