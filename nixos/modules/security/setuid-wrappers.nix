{pkgs, config, ...}:

with pkgs.lib;

let

  inherit (config.security) wrapperDir;

  setuidWrapper = pkgs.stdenv.mkDerivation {
    name = "setuid-wrapper";
    buildCommand = ''
      ensureDir $out/bin
      gcc -Wall -O2 -DWRAPPER_DIR=\"${wrapperDir}\" \
          ${./setuid-wrapper.c} -o $out/bin/setuid-wrapper
      strip -s $out/bin/setuid-wrapper
    '';
  };

in

{

  ###### interface

  options = {

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

    security.setuidOwners = mkOption {
      type = types.listOf types.attrs;
      default = [];
      example =
        [ { program = "sendmail";
            owner = "nobody";
            group = "postdrop";
            setuid = false;
            setgid = true;
          }
        ];
      description = ''
        This option allows the ownership and permissions on the setuid
        wrappers for specific programs to be overridden from the
        default (setuid root, but not setgid root).
      '';
    };

    security.wrapperDir = mkOption {
      internal = true;
      type = types.path;
      default = "/var/setuid-wrappers";
      description = ''
        This option defines the path to the setuid wrappers.  It
        should generally not be overriden. Some packages in Nixpkgs
        expect that <option>wrapperDir</option> is
        <filename>/var/setuid-wrappers</filename>.
      '';
    };

  };


  ###### implementation

  config = {

    security.setuidPrograms =
      [ "fusermount" "wodim" "cdrdao" "growisofs" ];

    system.activationScripts.setuid =
      let
        setuidPrograms =
          (map (x: { program = x; owner = "root"; group = "root"; setuid = true; })
            config.security.setuidPrograms)
          ++ config.security.setuidOwners;

        makeSetuidWrapper =
          { program
          , source ? ""
          , owner ? "nobody"
          , group ? "nogroup"
          , setuid ? false
          , setgid ? false
          , permissions ? "u+rx,g+x,o+x"
          }:

          ''
            source=${if source != "" then source else "$(PATH=$SETUID_PATH type -tP ${program})"}
            if test -z "$source"; then
                # If we can't find the program, fall back to the
                # system profile.
                source=/nix/var/nix/profiles/default/bin/${program}
            fi

            cp ${setuidWrapper}/bin/setuid-wrapper ${wrapperDir}/${program}
            echo -n "$source" > ${wrapperDir}/${program}.real
            chmod 0000 ${wrapperDir}/${program} # to prevent races
            chown ${owner}.${group} ${wrapperDir}/${program}
            chmod "u${if setuid then "+" else "-"}s,g${if setgid then "+" else "-"}s,${permissions}" ${wrapperDir}/${program}
          '';

      in stringAfter [ "users" ]
        ''
          # Look in the system path and in the default profile for
          # programs to be wrapped.
          SETUID_PATH=${config.system.path}/bin:${config.system.path}/sbin

          if test -d ${wrapperDir}; then rm -f ${wrapperDir}/*; fi # */
          mkdir -p ${wrapperDir}

          ${concatMapStrings makeSetuidWrapper setuidPrograms}
        '';

  };

}
