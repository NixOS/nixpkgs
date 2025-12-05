/*
  # Usage

  `emacs.pkgs.withPackages` takes a single argument: a function from a package
  set to a list of packages (the packages that will be available in
  Emacs). For example,
  ```
  emacs.pkgs.withPackages (epkgs: [ epkgs.evil epkgs.magit ])
  ```
  All the packages in the list should come from the provided package
  set. It is possible to add any package to the list, but the provided
  set is guaranteed to have consistent dependencies and be built with
  the correct version of Emacs.

  # Overriding

  `emacs.pkgs.withPackages` inherits the package set which contains it, so the
  correct way to override the provided package set is to override the
  set which contains `emacs.pkgs.withPackages`. For example, to override
  `emacs.pkgs.emacs.pkgs.withPackages`,
  ```
  let customEmacsPackages =
        emacs.pkgs.overrideScope (self: super: {
          # use a custom version of emacs
          emacs = ...;
          # use the unstable MELPA version of magit
          magit = self.melpaPackages.magit;
        });
  in customEmacsPackages.withPackages (epkgs: [ epkgs.evil epkgs.magit ])
  ```
*/

{
  lib,
  lndir,
  makeBinaryWrapper,
  runCommand,
}:
self:
let
  inherit (self) emacs;
  withNativeCompilation = emacs.withNativeCompilation or false;
  withTreeSitter = emacs.withTreeSitter or false;
in
packagesFun: # packages explicitly requested by the user
let
  explicitRequires = if lib.isFunction packagesFun then packagesFun self else packagesFun;
in
runCommand (lib.appendToName "with-packages" emacs).name
  {
    inherit emacs explicitRequires;
    nativeBuildInputs = [
      emacs
      lndir
      makeBinaryWrapper
    ];

    # Store all paths we want to add to emacs here, so that we only need to add
    # one path to the load lists
    deps =
      runCommand "emacs-packages-deps"
        (
          {
            inherit explicitRequires lndir emacs;
          }
          // lib.optionalAttrs withNativeCompilation {
            inherit (emacs) LIBRARY_PATH;
          }
        )
        ''
          findInputsOld() {
            local pkg="$1"; shift
            local var="$1"; shift
            local propagatedBuildInputsFiles=("$@")

            # TODO(@Ericson2314): Restore using associative array once Darwin
            # nix-shell doesn't use impure bash. This should replace the O(n)
            # case with an O(1) hash map lookup, assuming bash is implemented
            # well :D.
            local varSlice="$var[*]"
            # ''${..-} to hack around old bash empty array problem
            case " ''${!varSlice-} " in
                *" $pkg "*) return 0 ;;
            esac
            unset -v varSlice

            eval "$var"'+=("$pkg")'

            if ! [ -e "$pkg" ]; then
                echo "build input $pkg does not exist" >&2
                exit 1
            fi

            local file
            for file in "''${propagatedBuildInputsFiles[@]}"; do
                file="$pkg/nix-support/$file"
                [[ -f "$file" ]] || continue

                local pkgNext
                for pkgNext in $(< "$file"); do
                    findInputsOld "$pkgNext" "$var" "''${propagatedBuildInputsFiles[@]}"
                done
            done
          }
          mkdir -p $out/bin
          mkdir -p $out/share/emacs/site-lisp
          ${lib.optionalString withNativeCompilation ''
            mkdir -p $out/share/emacs/native-lisp
          ''}
          ${lib.optionalString withTreeSitter ''
            mkdir -p $out/lib
          ''}

          local requires
          for pkg in $explicitRequires; do
            findInputsOld $pkg requires propagated-user-env-packages
          done
          # requires now holds all requested packages and their transitive dependencies

          linkPath() {
            local pkg=$1
            local origin_path=$2
            local dest_path=$3

            # Add the path to the search path list, but only if it exists.
            # Executables in /bin are linked by their resolved paths in case they are
            # relative symlinks (which break when 'lndir'ed as is);
            # see https://github.com/NixOS/nixpkgs/issues/395442
            if [[ -d "$pkg/$origin_path" ]]; then
              case "$origin_path" in
                bin)
                  for exe in $pkg/$origin_path/*; do
                    ln -s "$(realpath "$exe")" "$out/$dest_path/$(basename "$exe")"
                  done
                  ;;
                *) $lndir/bin/lndir -silent "$pkg/$origin_path" "$out/$dest_path";;
              esac
            fi
          }

          linkEmacsPackage() {
            linkPath "$1" "bin" "bin"
            linkPath "$1" "share/emacs/site-lisp" "share/emacs/site-lisp"
            ${lib.optionalString withNativeCompilation ''
              linkPath "$1" "share/emacs/native-lisp" "share/emacs/native-lisp"
            ''}
            ${lib.optionalString withTreeSitter ''
              linkPath "$1" "lib" "lib"
            ''}
          }

          # Iterate over the array of inputs (avoiding nix's own interpolation)
          for pkg in "''${requires[@]}"; do
            linkEmacsPackage $pkg
          done

          siteStart="$out/share/emacs/site-lisp/site-start.el"
          siteStartByteCompiled="$siteStart"c
          subdirs="$out/share/emacs/site-lisp/subdirs.el"
          subdirsByteCompiled="$subdirs"c

          # A dependency may have brought the original siteStart or subdirs, delete
          # it and create our own
          # Begin the new site-start.el by loading the original, which sets some
          # NixOS-specific paths. Paths are searched in the reverse of the order
          # they are specified in, so user and system profile paths are searched last.
          #
          # NOTE: Avoid displaying messages early at startup by binding
          # inhibit-message to t. This would prevent the Emacs GUI from showing up
          # prematurely. The messages would still be logged to the *Messages*
          # buffer.
          rm -f $siteStart $siteStartByteCompiled $subdirs $subdirsByteCompiled
          cat >"$siteStart" <<EOF
          ;;; -*- lexical-binding: t -*-
          (let ((inhibit-message t))
            (load "$emacs/share/emacs/site-lisp/site-start"))
          ;; "$out/share/emacs/site-lisp" is added to load-path in wrapper.sh
          ;; "$out/share/emacs/native-lisp" is added to native-comp-eln-load-path in wrapper.sh
          (add-to-list 'exec-path "$out/bin")
          ${lib.optionalString withTreeSitter ''
            (add-to-list 'treesit-extra-load-path "$out/lib/")
          ''}
          EOF

          # Generate a subdirs.el that statically adds all subdirectories to load-path.
          cat >"$subdirs" <<EOF
          ;;; -*- lexical-binding: t -*-
          EOF
          $emacs/bin/emacs \
            --batch \
            --load ${./mk-wrapper-subdirs.el} \
            --eval "(prin1 (macroexpand-1 '(mk-subdirs-expr \"$out/share/emacs/site-lisp\")))" \
            >> "$subdirs"

          # Byte-compiling improves start-up time only slightly, but costs nothing.
          $emacs/bin/emacs --batch -f batch-byte-compile "$siteStart" "$subdirs"

          ${lib.optionalString withNativeCompilation ''
            $emacs/bin/emacs --batch \
              --eval "(add-to-list 'native-comp-eln-load-path \"$out/share/emacs/native-lisp/\")" \
              -f batch-native-compile "$siteStart" "$subdirs"
          ''}
        '';

    inherit (emacs) meta;
  }
  ''
    mkdir -p "$out/bin"

    # Wrap emacs and friends so they find our site-start.el before the original.
    for prog in $emacs/bin/*; do # */
      local progname=$(basename "$prog")
      rm -f "$out/bin/$progname"

      substitute ${./wrapper.sh} $out/bin/$progname \
        --subst-var-by bash ${emacs.stdenv.shell} \
        --subst-var-by wrapperSiteLisp "$deps/share/emacs/site-lisp" \
        --subst-var-by wrapperSiteLispNative "$deps/share/emacs/native-lisp" \
        --subst-var-by wrapperInvocationDirectory "$out/bin/" \
        --subst-var-by wrapperInvocationName "$progname" \
        --subst-var prog
      chmod +x $out/bin/$progname
      # Create a “NOP” binary wrapper for the pure sake of it becoming a
      # non-shebang, actual binary. See the makeBinaryWrapper docs for rationale
      # (summary: it allows you to use emacs as a shebang itself on Darwin,
      # e.g. #!$ {emacs}/bin/emacs --script)
      wrapProgramBinary $out/bin/$progname
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


      substitute ${./wrapper.sh} $out/Applications/Emacs.app/Contents/MacOS/Emacs \
        --subst-var-by bash ${emacs.stdenv.shell} \
        --subst-var-by wrapperSiteLisp "$deps/share/emacs/site-lisp" \
        --subst-var-by wrapperSiteLispNative "$deps/share/emacs/native-lisp" \
        --subst-var-by wrapperInvocationDirectory "$out/Applications/Emacs.app/Contents/MacOS/" \
        --subst-var-by wrapperInvocationName "Emacs" \
        --subst-var-by prog "$emacs/Applications/Emacs.app/Contents/MacOS/Emacs"
      chmod +x $out/Applications/Emacs.app/Contents/MacOS/Emacs
      wrapProgramBinary $out/Applications/Emacs.app/Contents/MacOS/Emacs
    fi

    mkdir -p $out/share
    # Link icons and desktop files into place
    for dir in applications icons info man; do
      ln -s $emacs/share/$dir $out/share/$dir
    done
  ''
