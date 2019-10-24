# Build up a directory of binaries, that will transparently install from <nixpkgs> and call into their real package
# This is for binaries, that you want on your path, but not necessarily wait for, on system update

# The approach is to build a busybox-like bin-folder, soft linking to
# a single dispatcher/installer/launcher script

## TODOS
# - Mechanism to prefetch packages making out the lazy path. Possibly with priorities
# - Mechanism to keep using previous versions, until the most recent version has been downloaded / built
# - Support for generating the catalog on hydra (right now requires manual management)
# - Detect collisions / offer options to prioritize, or even handle (zenity) on call
# - Support for renaming binaries
# - Progress report (zenity), while downloading / building a package
# - provide proper shell environments per package (maybe go through nix-shell -p)

{ stdenv, lib, writeScript, runCommand, nix, coreutils }:

## NOTE about <nixpkgs> `toString <nixpkgs>` will lazy bind: updating
# <nixpkgs>'s content should immediately reflect in lazy binaries.  To
# achieve a static binding, where lazy-packages needs to be rebuilt,
# in order to see changes, just pass <nixpkgs>
{ nixpkgs ? toString <nixpkgs>
, catalog ? { } # package = [ binary binary .. ]; eg { \"utillinux\" = [ \"addpart\" \"agetty\" ... ]; ... }"
, installed ? throw "Please set commands to install lazily; eg [ \"addpart\" \"ionice\" \"lscpu\" ... ]"
}:

with lib;
let
  binaryCatalog = listToAttrs
    (concatLists
      (mapAttrsToList
        (value: bins:
          map (name: { inherit name value; })
            bins)
        catalog));
in

# Here the dispatcher/installer/launcher script is built
# it has a case "$0" in cmd) ... esac
# and builds the package via nix, before calling the binary

# TODO base case should suggest package to install, based on catalog

runCommand "lazy-binaries" {
  inherit installed;
  launcher = writeScript "lazy-binaries-launcher" ''
    #!${stdenv.shell} -e
    execBinary () {
      p="$1"
      bin="$2"
      shift; shift
      exec "$("${nix}/bin/nix-build" --no-out-link "${nixpkgs}" -A "$p")/bin/$bin" "$@"
    }
    case "$(exec ${coreutils}/bin/basename "$0")" in
    ${concatStrings
      (map
        (bin: ''
          "${bin}") execBinary "${binaryCatalog.${bin} or bin}" "${bin}" "$@" ;;
        '')
        installed)
     }*)
      echo "Uninstalled: '$0'" >&2
      exit 1
      ;;
    esac
  '';

  # Here the link farm is built

  # TODO package names providing same binary are random, r/n
} ''
  mkdir -p $out/bin
  cd $out/bin
  for p in ''${installed[@]}
  do
    ln -s $launcher $p
  done
''
