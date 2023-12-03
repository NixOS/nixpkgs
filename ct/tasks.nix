#
# This derivation builds a Makefile, which is then passed to gmake
# in order to perform the necessary CT tasks, with correct
# dependency ordering and as much parallelism as possible.
#
# A Makefile is used solely because we need access to the Nix store
# (which contains cached artifacts from previous CT runs) in order
# to get reasonable performance.  Since recursive-nix is neither
# stable nor ready for use, a Makefile is the simple interim solution.
#
# The Makefile contains one big target which runs nix-build on
# several attributes.  In general you should try to express your CT
# target by adding additional attributes to this list.  Please add
# new Makefile targets or shellscript only as a last resort.
#

{ pkgs-path ? ../.
, shortRev ? builtins.substring 0 8 (lib.commitIdFromGitRepo ../.git)
, pkgs ? import pkgs-path {}
, lib ? pkgs.lib
}:

let

  # Attrset where the attrname is the target name and the attrvalue
  # becomes the lines to be used.  No tab characters needed.
  #
  # These commands are executed "outside of" nix-build, so they have
  # access to the shared store which will retain cached artifacts
  # across CT runs.
  #
  targets = {
    pkgs-test-release =''
      ${pkgs.nix}/bin/nix-build ./pkgs/test/release
    '';

    /*
    libtests = ''
      ${pkgs.nix}/bin/nix-build ./lib/tests/release.nix
    '';
    */
  };

in
pkgs.mkShell {
  pname = "nixpkgs-ct";
  version = shortRev;

  passAsFile = [ "makefile" ];
  makefile = ''
    ${lib.concatStrings
      (lib.mapAttrsToList
        (name: val:
          ''
          .PHONY: ${name}
          default: ${name}
          ${name}:
          ${lib.concatStringsSep "\n"
            (map (line: if line=="" then "" else "\t${line}")
              (lib.splitString "\n" val))}
          '')
        targets)}
  '';

  shellHook = ''
    unset shellHook
    set -eu -o pipefail
    ${pkgs.gnumake}/bin/make -k -j -f $makefilePath default
  '';
}
