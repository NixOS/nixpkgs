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
      emacsPackagesNg.overrideScope (super: self: {
        # use a custom version of emacs
        emacs = ...;
        # use the unstable MELPA version of magit
        magit = self.melpaPackages.magit;
      });
in customEmacsPackages.emacsWithPackages (epkgs: [ epkgs.evil epkgs.magit ])
```

*/

{ lib, lndir, makeWrapper, runCommand, stdenv }: self:

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

  # Store all paths we want to add to emacs here, so that we only need to add
  # one path to the load lists
  deps = runCommand "emacs-packages-deps"
   { inherit explicitRequires lndir emacs; }
   ''
     mkdir -p $out/bin
     mkdir -p $out/share/emacs/site-lisp

     local requires
     for pkg in $explicitRequires; do
       findInputs $pkg requires propagated-user-env-packages
     done
     # requires now holds all requested packages and their transitive dependencies

     linkPath() {
       local pkg=$1
       local origin_path=$2
       local dest_path=$3

       # Add the path to the search path list, but only if it exists
       if [[ -d "$pkg/$origin_path" ]]; then
         $lndir/bin/lndir -silent "$pkg/$origin_path" "$out/$dest_path"
       fi
     }

     linkEmacsPackage() {
       linkPath "$1" "bin" "bin"
       linkPath "$1" "share/emacs/site-lisp" "share/emacs/site-lisp"
     }

     # Iterate over the array of inputs (avoiding nix's own interpolation)
     for pkg in "''${requires[@]}"; do
       linkEmacsPackage $pkg
     done

     siteStart="$out/share/emacs/site-lisp/site-start.el"
     siteStartByteCompiled="$siteStart"c

     # A dependency may have brought the original siteStart, delete it and
     # create our own
     # Begin the new site-start.el by loading the original, which sets some
     # NixOS-specific paths. Paths are searched in the reverse of the order
     # they are specified in, so user and system profile paths are searched last.
     rm -f $siteStart $siteStartByteCompiled
     cat >"$siteStart" <<EOF
(load-file "$emacs/share/emacs/site-lisp/site-start.el")
(add-to-list 'load-path "$out/share/emacs/site-lisp")
(add-to-list 'exec-path "$out/bin")
EOF

     # Byte-compiling improves start-up time only slightly, but costs nothing.
     $emacs/bin/emacs --batch -f batch-byte-compile "$siteStart"
  '';

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p "$out/bin"

    # Wrap emacs and friends so they find our site-start.el before the original.
    for prog in $emacs/bin/*; do # */
      local progname=$(basename "$prog")
      rm -f "$out/bin/$progname"
      makeWrapper "$prog" "$out/bin/$progname" \
        --suffix EMACSLOADPATH ":" "$deps/share/emacs/site-lisp:"
    done

    # Wrap MacOS app
    # this has to pick up resources and metadata
    # to recognize it as an "app"
    if [ -d "$emacs/Applications/Emacs.app" ]; then
      mkdir -p $out/Applications/Emacs.app/Contents/MacOS
      cp -r $emacs/Applications/Emacs.app/Contents/Info.plist \
            $emacs/Applications/Emacs.app/Contents/PkgInfo \
            $emacs/Applications/Emacs.app/Contents/Resources \
            $out/Applications/Emacs.app/Contents
      makeWrapper $emacs/Applications/Emacs.app/Contents/MacOS/Emacs $out/Applications/Emacs.app/Contents/MacOS/Emacs \
        --suffix EMACSLOADPATH ":" "$deps/share/emacs/site-lisp:"
    fi

    mkdir -p $out/share
    # Link icons and desktop files into place
    for dir in applications icons info man; do
      ln -s $emacs/share/$dir $out/share/$dir
    done
  '';
  inherit (emacs) meta;
}
