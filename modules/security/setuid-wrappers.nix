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
      default = [];
      description = ''
        Only the programs from system path listed here will be made
        setuid root (through a wrapper program).
      '';
    };

    security.extraSetuidPrograms = mkOption {
      default = [];
      example = ["fusermount"];
      description = ''
        This option lists additional programs that must be made setuid
        root. Obsolete, use setuidPrograms instead.
      '';
    };

    security.setuidOwners = mkOption {
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
        wrappers for specific programs to be overriden from the
        default (setuid root, but not setgid root).
      '';
    };

    security.wrapperDir = mkOption {
      default = "/var/setuid-wrappers";
      description = ''
        This option defines the path to the setuid wrappers.  It
        should generally not be overriden. Some packages in nixpkgs rely on
        wrapperDir == /var/setuid-wrappers
      '';
    };

  };


  ###### implementation

  config = {

    security.setuidPrograms =
      [ "crontab" "fusermount" "wodim" "cdrdao" "growisofs" ];

    system.activationScripts.setuid =
      let
        setuidPrograms =
          (map (x: { program = x; owner = "root"; group = "root"; setuid = true; })
            (config.security.setuidPrograms ++
             config.security.extraSetuidPrograms))
          ++ config.security.setuidOwners;

        makeSetuidWrapper =
          { program
          , source ? ""
          , owner ? "nobody"
          , group ? "nogroup"
          , setuid ? false
          , setgid ? false
          , permissions ? "u+rx,g+rx,o+rx"
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

      in pkgs.stringsWithDeps.fullDepEntry
        ''
          # Look in the system path and in the default profile for
          # programs to be wrapped.
          SETUID_PATH=${config.system.path}/bin:${config.system.path}/sbin

          if test -d ${wrapperDir}; then rm -f ${wrapperDir}/*; fi # */
          mkdir -p ${wrapperDir}

          ${concatMapStrings makeSetuidWrapper setuidPrograms}
        '' [ "defaultPath" "users" ];

  };
  
}
