{ config, lib, pkgs, ... }:
let

  inherit (config.security) wrapperDir;

  wrappers  = config.security.wrappers;
  mkWrapper = { program, source ? null, ...}: ''
    if ! source=${if source != null then source else "$(readlink -f $(PATH=$WRAPPER_PATH type -tP ${program}))"}; then
        # If we can't find the program, fall back to the
        # system profile.
        source=/nix/var/nix/profiles/default/bin/${program}
    fi

    gcc -Wall -O2 -DSOURCE_PROG=\"$source\" -DWRAPPER_DIR=\"${config.security.wrapperDir}\" \
        -lcap-ng -lcap ${./wrapper.c} -o $out/bin/${program}.wrapper -L ${pkgs.libcap.lib}/lib -L ${pkgs.libcap_ng}/lib \
        -I ${pkgs.libcap.dev}/include -I ${pkgs.libcap_ng}/include -I ${pkgs.linuxHeaders}/include
  '';

  wrappedPrograms = pkgs.stdenv.mkDerivation {
    name         = "permissions-wrapper";
    unpackPhase  = "true";
    installPhase = ''
      mkdir -p $out/bin
      ${lib.concatMapStrings mkWrapper wrappers}
    '';
  };

  ###### Activation script for the setcap wrappers
  mkSetcapProgram =
    { program
    , capabilities
    , source ? null
    , owner  ? "nobody"
    , group  ? "nogroup"
    ...
    }: 
    assert (lib.versionAtLeast (lib.getVersion config.boot.kernelPackages.kernel) "4.3");
    ''
      cp ${wrappedPrograms}/bin/${program}.wrapper $wrapperDir/${program}

      # Prevent races
      chmod 0000 $wrapperDir/${program}
      chown ${owner}.${group} $wrapperDir/${program}

      # Set desired capabilities on the file plus cap_setpcap so
      # the wrapper program can elevate the capabilities set on
      # its file into the Ambient set.
      ${pkgs.libcap.out}/bin/setcap "cap_setpcap,${capabilities}" $wrapperDir/${program}

      # Set the executable bit
      chmod u+rx,g+x,o+x $wrapperDir/${program}
    '';

  ###### Activation script for the setuid wrappers
  mkSetuidProgram =
    { program
    , source ? null
    , owner  ? "nobody"
    , group  ? "nogroup"
    , setuid ? false
    , setgid ? false
    , permissions ? "u+rx,g+x,o+x"
    ...
    }: ''
      cp ${wrappedPrograms}/bin/${program}.wrapper $wrapperDir/${program}

      # Prevent races
      chmod 0000 $wrapperDir/${program}
      chown ${owner}.${group} $wrapperDir/${program}

      chmod "u${if setuid then "+" else "-"}s,g${if setgid then "+" else "-"}s,${permissions}" $wrapperDir/${program}
    '';
in
{

  ###### interface

  options = {
    security.wrappers.setcap = lib.mkOption {
      type    = lib.types.listOf lib.types.attrs;
      default = [];
      example =
        [ { program = "ping";
            source  = "${pkgs.iputils.out}/bin/ping";
            owner   = "nobody";
            group   = "nogroup";
            capabilities = "cap_net_raw+ep";
          }
        ];
      description = ''
        This option sets capabilities on a wrapper program that
        propagates those capabilities down to the wrapped, real
        program.

        The <literal>program</literal> attribute is the name of the
        program to be wrapped. If no <literal>source</literal>
        attribute is provided, specifying the absolute path to the
        program, then the program will be searched for in the path
        environment variable.

        NOTE: cap_setpcap, which is required for the wrapper program
        to be able to raise caps into the Ambient set is NOT raised to
        the Ambient set so that the real program cannot modify its own
        capabilities!! This may be too restrictive for cases in which
        the real program needs cap_setpcap but it at least leans on
        the side security paranoid vs. too relaxed.
      '';
    };

    security.setuidPrograms = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["passwd"];
      description = ''
        The Nix store cannot contain setuid/setgid programs directly.
        For this reason, NixOS can automatically generate wrapper
        programs that have the necessary privileges.  This option
        lists the names of programs in the system environment for
        which setuid root wrappers should be created.
      '';
    };

    security.wrappers = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      example = {
        sendmail.source = "/nix/store/.../bin/sendmail";
      };
      description = ''
        This option allows the ownership and permissions on the setuid
        wrappers for specific programs to be overridden from the
        default (setuid root, but not setgid root).
      '';
    };

    security.old-wrapperDir = lib.mkOption {
      type        = lib.types.path;
      default     = "/var/setuid-wrappers";
      internal    = true;
      description = ''
        This option defines the path to the wrapper programs. It
        should not be overriden.
      '';
    };

    security.wrapperDir = lib.mkOption {
      type        = lib.types.path;
      default     = "/run/wrappers";
      internal    = true;
      description = ''
        This option defines the path to the wrapper programs. It
        should not be overriden.
      '';
    };
  };

  ###### implementation
  config = {
    # Make sure our wrapperDir exports to the PATH env variable when
    # initializing the shell
    environment.extraInit = ''
      # Wrappers override other bin directories.
      export PATH="${wrapperDir}:$PATH"
    '';

    ###### setcap activation script
    system.activationScripts.wrappers =
      let
        programs =
          (map (x: { program = x; owner = "root"; group = "root"; setuid = true; })
            config.security.setuidPrograms)
            ++ lib.mapAttrsToList
                 (n: v: (if v ? "program" then v else v // {program=n;}))
                 wrappers;

        mkWrappedPrograms =
          builtins.map
            (s: if (s ? "capabilities")
                then mkSetcapProgram s
                else if 
                   (s ? "setuid"  && s.setuid  == true) ||
                   (s ? "setguid" && s.setguid == true) ||
                   (s ? "permissions")
                then mkSetuidProgram s
                else ""
            ) programs;

      in lib.stringAfter [ "users" ]
        ''
          # Look in the system path and in the default profile for
          # programs to be wrapped.
          WRAPPER_PATH=${config.system.path}/bin:${config.system.path}/sbin

          mkdir -p ${wrapperDir}
          wrapperDir=$(mktemp --directory --tmpdir=${wrapperDir} wrappers.XXXXXXXXXX)
          chmod a+rx $wrapperDir

          ${lib.concatStringsSep "\n" mkWrappedPrograms}
        '';
  };
}
