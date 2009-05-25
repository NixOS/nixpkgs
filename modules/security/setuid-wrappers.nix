{pkgs, config, ...}:

with pkgs.lib;

let

  options = {
    security = {
      setuidPrograms = mkOption {
        default = [
          "passwd" "su" "crontab" "ping" "ping6"
          "fusermount" "wodim" "cdrdao" "growisofs"
        ];
        description = ''
          Only the programs from system path listed her will be made setuid root
          (through a wrapper program).  It's better to set
          <option>security.extraSetuidPrograms</option>.
        '';
      };

      # !!! obsolete
      extraSetuidPrograms = mkOption {
        default = [];
        example = ["fusermount"];
        description = ''
          This option lists additional programs that must be made setuid
          root.
        '';
      };

      setuidOwners = mkOption {
        default = [];
        example = [{
          program = "sendmail";
          owner = "nobody";
          group = "postdrop";
          setuid = false;
          setgid = true;
        }];
        description = ''
          This option allows the ownership and permissions on the setuid
          wrappers for specific programs to be overriden from the
          default (setuid root, but not setgid root).
        '';
      };

      wrapperDir = mkOption {
        default = "/var/setuid-wrappers";
        description = ''
          This option defines the path to the setuid wrappers.  It
          should generally not be overriden.
        '';
      };
    };
  };

  setuidWrapper = pkgs.stdenv.mkDerivation {
    name = "setuid-wrapper";
    buildCommand = ''
      ensureDir $out/bin
      gcc -Wall -O2 -DWRAPPER_DIR=\"${config.security.wrapperDir}\" ${./setuid-wrapper.c} -o $out/bin/setuid-wrapper
      strip -s $out/bin/setuid-wrapper
    '';
  };

in

{
  require = [options];

  system = {
    activationScripts = {
      setuid =
        let
          setuidPrograms = builtins.toString (
            config.security.setuidPrograms ++
            config.security.extraSetuidPrograms ++
            map (x: x.program) config.security.setuidOwners
          );

          adjustSetuidOwner = concatStrings (map
            (_entry: let entry = {
              owner = "nobody";
              group = "nogroup";
              setuid = false;
              setgid = false;
            } //_entry; in
            ''
              chown ${entry.owner}.${entry.group} $wrapperDir/${entry.program}
              chmod u${if entry.setuid then "+" else "-"}s $wrapperDir/${entry.program} 
              chmod g${if entry.setgid then "+" else "-"}s $wrapperDir/${entry.program}
            '')
            config.security.setuidOwners);

        in fullDepEntry ''
          # Look in the system path and in the default profile for
          # programs to be wrapped.  However, having setuid programs
          # in a profile is problematic, since the NixOS activation
          # script won't be rerun automatically when you install a
          # wrappable program in the profile with nix-env.
          SETUID_PATH=/nix/var/nix/profiles/default/sbin:/nix/var/nix/profiles/default/bin:${config.system.path}/bin:${config.system.path}/sbin

          wrapperDir=${config.security.wrapperDir}
          if test -d $wrapperDir; then rm -f $wrapperDir/*; fi # */
          mkdir -p $wrapperDir
          
          for i in ${setuidPrograms}; do
              program=$(PATH=$SETUID_PATH type -tP $i)
              if test -z "$program"; then
                  # XXX: It would be preferable to detect this problem before
                  # `activate-configuration' is invoked.
                  #echo "WARNING: No executable named \`$i' was found" >&2
                  #echo "WARNING: but \`$i' was specified as a setuid program." >&2
                  true
              else
                  cp ${setuidWrapper}/bin/setuid-wrapper $wrapperDir/$i
                  echo -n "$program" > $wrapperDir/$i.real
                  chown root.root $wrapperDir/$i
                  chmod 4755 $wrapperDir/$i
              fi
          done

          ${adjustSetuidOwner}
        '' [ "defaultPath" "users" ];
    };
  };
}
