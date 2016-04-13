/*

# Usage

`emacsWithPackages` takes a single argument: a function from a package
set to a list of packages (the packages that will be available in
Emacs). For example,
```
emacsWithPackages (epkgs: [ epkgs.evil epkgs.magit ])
```
All the packages in the list should come from the provided package
set. It is possible to add any package to the list, but the provided
set is guaranteed to have consistent dependencies and be built with
the correct version of Emacs.

# Overriding

`emacsWithPackages` inherits the package set which contains it, so the
correct way to override the provided package set is to override the
set which contains `emacsWithPackages`. For example, to override
`emacsPackagesNg.emacsWithPackages`,
```
let customEmacsPackages =
      emacsPackagesNg.override (super: self: {
        # use a custom version of emacs
        emacs = ...;
        # use the unstable MELPA version of magit
        magit = self.melpaPackages.magit;
      });
in customEmacsPackages.emacsWithPackages (epkgs: [ epkgs.evil epkgs.magit ])
```

*/

{ lib, lndir, makeWrapper, stdenv }: self:

with lib; let inherit (self) emacs; in

packagesFun: # packages explicitly requested by the user

let
  explicitRequires =
    if builtins.isFunction packagesFun
      then packagesFun self
    else packagesFun;
in

stdenv.mkDerivation {
  name = (appendToName "with-packages" emacs).name;
  nativeBuildInputs = [ emacs lndir makeWrapper ];
  inherit emacs explicitRequires;
  phases = [ "installPhase" ];
  installPhase = ''
    readonly SHARE="share/emacs-with-packages"

    mkdir -p "$out/bin"
    mkdir -p "$out/$SHARE/bin"
    mkdir -p "$out/$SHARE/site-lisp"

    local requires
    for pkg in $explicitRequires; do
      findInputs $pkg requires propagated-user-env-packages
    done
    # requires now holds all requested packages and their transitive dependencies

    siteStart="$out/$SHARE/site-lisp/site-start.el"

    # Begin the new site-start.el by loading the original, which sets some
    # NixOS-specific paths. Paths are searched in the reverse of the order
    # they are specified in, so user and system profile paths are searched last.
    cat >"$siteStart" <<EOF
(load-file "$emacs/share/emacs/site-lisp/site-start.el")
(add-to-list 'load-path "$out/$SHARE/site-lisp")
(add-to-list 'exec-path "$out/$SHARE/bin")
EOF

    linkPath() {
      local pkg=$1
      local origin_path=$2
      local dest_path=$3

      # Add the path to the search path list, but only if it exists
      if [[ -d "$pkg/$origin_path" ]]; then
        lndir -silent "$pkg/$origin_path" "$out/$dest_path"
      fi
    }

    # Add a package's paths to site-start.el
    linkEmacsPackage() {
      linkPath "$1" "bin" "$SHARE/bin"
      linkPath "$1" "share/emacs/site-lisp" "$SHARE/site-lisp"
    }

    # First, link all the explicitly-required packages.
    for pkg in $explicitRequires; do
      linkEmacsPackage $pkg
    done

    # Next, link all the dependencies.
    for pkg in $requires; do
      linkEmacsPackage $pkg
    done

    # Byte-compiling improves start-up time only slightly, but costs nothing.
    emacs --batch -f batch-byte-compile "$siteStart"

    # Wrap emacs and friends so they find our site-start.el before the original.
    for prog in $emacs/bin/*; do # */
      local progname=$(basename "$prog")
      rm -f "$out/bin/$progname"
      makeWrapper "$prog" "$out/bin/$progname" \
        --suffix EMACSLOADPATH ":" "$out/$SHARE/site-lisp:"
    done

    mkdir -p $out/share
    # Link icons and desktop files into place
    for dir in applications icons info man; do
      ln -s $emacs/share/$dir $out/share/$dir
    done
  '';
  inherit (emacs) meta;
}
