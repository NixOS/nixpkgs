{ stdenv, lib, runCommandNoCC, runtimeShell, libcap, libcap_ng, linuxHeaders }:
# TODO: Add this assertion somewhere?
# assert (lib.versionAtLeast (lib.getVersion config.boot.kernelPackages.kernel) "4.3");

# See <nixpkgs/nixos/modules/security/wrappers> for documentation on these two values
{ wrappers, wrapperDir }:
let

  parentWrapperDir = dirOf wrapperDir;

  programs = lib.mapAttrsToList
    (n: v: (if v ? "program" then v else v // {program=n;}))
    wrappers;

  securityWrapper = stdenv.mkDerivation {
    name            = "security-wrapper";
    phases          = [ "installPhase" "fixupPhase" ];
    buildInputs     = [ libcap libcap_ng linuxHeaders ];
    hardeningEnable = [ "pie" ];
    installPhase = ''
      mkdir -p $out/bin
      $CC -Wall -O2 -DWRAPPER_DIR=\"${parentWrapperDir}\" \
          -lcap-ng -lcap ${./wrapper.c} -o $out/bin/security-wrapper
    '';
  };

  ###### Activation script for the setcap wrappers
  mkSetcapProgram =
    { program
    , capabilities
    , source
    , owner  ? "nobody"
    , group  ? "nogroup"
    , permissions ? "u+rx,g+x,o+x"
    , ...
    }:
    ''
      cp "${securityWrapper}/bin/security-wrapper" "$wrapperDir/${program}"
      echo -n "${source}" > "$wrapperDir/${program}.real"

      # Prevent races
      chmod 0000 "$wrapperDir/${program}"
      chown ${owner}.${group} "$wrapperDir/${program}"

      # Set desired capabilities on the file plus cap_setpcap so
      # the wrapper program can elevate the capabilities set on
      # its file into the Ambient set.
      ${libcap.out}/bin/setcap "cap_setpcap,${capabilities}" "$wrapperDir/${program}"

      # Set the executable bit
      chmod ${permissions} "$wrapperDir/${program}"
    '';

  ###### Activation script for the setuid wrappers
  mkSetuidProgram =
    { program
    , source
    , owner  ? "nobody"
    , group  ? "nogroup"
    , setuid ? false
    , setgid ? false
    , permissions ? "u+rx,g+x,o+x"
    , ...
    }:
    ''
      cp ${securityWrapper}/bin/security-wrapper "$wrapperDir/${program}"
      echo -n "${source}" > "$wrapperDir/${program}.real"

      # Prevent races
      chmod 0000 "$wrapperDir/${program}"
      chown ${owner}.${group} "$wrapperDir/${program}"

      chmod "u${if setuid then "+" else "-"}s,g${if setgid then "+" else "-"}s,${permissions}" "$wrapperDir/${program}"
    '';

  mkWrappedPrograms =
    builtins.map
      (s: if (s ? "capabilities")
          then mkSetcapProgram
                 ({ owner = "root";
                    group = "root";
                  } // s)
          else if
             (s ? "setuid" && s.setuid) ||
             (s ? "setgid" && s.setgid) ||
             (s ? "permissions")
          then mkSetuidProgram s
          else mkSetuidProgram
                 ({ owner  = "root";
                    group  = "root";
                    setuid = true;
                    setgid = false;
                    permissions = "u+rx,g+x,o+x";
                  } // s)
                  ) programs;

in runCommandNoCC "wrappers" {
  passAsFile = [ "setup" "teardown" ];
  setup = ''
    #!${runtimeShell}

    set -e

    echo "Setting up security wrappers" >&2

    mkdir -p "${parentWrapperDir}"
    mount -t tmpfs -o nodev tmpfs "${parentWrapperDir}"

    # We want to place the tmpdirs for the wrappers to the parent dir.
    wrapperDir=$(mktemp --directory --tmpdir="${parentWrapperDir}" wrappers.XXXXXXXXXX)
    chmod a+rx "$wrapperDir"

    ${lib.concatStringsSep "\n" mkWrappedPrograms}

    if [ -L "${wrapperDir}" ]; then
      # Atomically replace the symlink
      # See https://axialcorps.com/2013/07/03/atomically-replacing-files-and-directories/
      old=$(readlink -f "${wrapperDir}")
      ln --symbolic --force --no-dereference "$wrapperDir" "${wrapperDir}-tmp"
      mv --no-target-directory "${wrapperDir}-tmp" "${wrapperDir}"
      rm --force --recursive "$old"
    else
      # For initial setup
      ln --symbolic "$wrapperDir" "${wrapperDir}"
    fi
  '';
  teardown = ''
    #!${runtimeShell}
    echo "Tearing down security wrappers" >&2

    umount "${parentWrapperDir}"
    rmdir "${parentWrapperDir}"
  '';
} ''
  mkdir -p $out/bin
  mv "$setupPath" $out/bin/setup
  chmod +x $out/bin/setup
  mv "$teardownPath" $out/bin/teardown
  chmod +x $out/bin/teardown
''
