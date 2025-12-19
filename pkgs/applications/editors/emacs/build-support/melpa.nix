# builder for Emacs packages built for packages.el
# using MELPA package-build.el

{
  lib,
  stdenv,
  fetchFromGitHub,
  emacs,
  texinfo,
}:

let
  genericBuild = import ./generic.nix {
    inherit
      lib
      stdenv
      emacs
      texinfo
      ;
  };

  packageBuild = stdenv.mkDerivation {
    name = "package-build";
    src = fetchFromGitHub {
      owner = "melpa";
      repo = "package-build";
      rev = "d1722503145facf96631ac118ec0213a73082b76";
      hash = "sha256-utsZLm9IF9UkTwxFWvJmwA3Ox4tlMeNNTo+f/CqYJGA=";
    };

    prePatch = ''
      substituteInPlace package-build.el \
        --replace-fail '(format "--mtime=@%d" time)' '"--mtime=@0"'
    '';

    dontConfigure = true;
    dontBuild = true;

    installPhase = "
      mkdir -p $out
      cp -r * $out
    ";
  };

in

lib.extendMkDerivation {
  constructDrv = genericBuild;
  extendDrvArgs =
    finalAttrs:

    {
      /*
        pname: Nix package name without special symbols and without version or
        "emacs-" prefix.
      */
      pname,
      /*
        ename: Original Emacs package name, possibly containing special symbols.
        Default: pname
      */
      ename ? pname,
      /*
        version: Either a stable version such as "1.2" or an unstable version.
        An unstable version can use either Nix format (preferred) such as
        "1.2-unstable-2024-06-01" or MELPA format such as "20240601.1230".
      */
      version,
      /*
        commit: Optional package history commit.
        Default: src.rev or "unknown"
        This will be written into the generated package but it is not needed during
        the build process.
      */
      commit ? (finalAttrs.src.rev or "unknown"),
      /*
        files: Optional recipe property specifying the files used to build the package.
        If null, do not set it in recipe, keeping the default upstream behaviour.
        Default: null
      */
      files ? null,
      /*
        recipe: Optional MELPA recipe.
        Default: a minimally functional recipe
        This can be a path of a recipe file, a string of the recipe content or an empty string.
        The default value is used if it is an empty string.
      */
      recipe ? "",
      preUnpack ? "",
      postUnpack ? "",
      meta ? { },
      ...
    }@args:

    {

      elpa2nix = args.elpa2nix or ./elpa2nix.el;
      melpa2nix = args.melpa2nix or ./melpa2nix.el;

      inherit
        commit
        ename
        files
        recipe
        ;

      packageBuild = args.packageBuild or packageBuild;

      melpaVersion =
        args.melpaVersion or (
          let
            parsed =
              lib.flip builtins.match finalAttrs.version
                # match <version>-unstable-YYYY-MM-DD format
                "^.*-unstable-([[:digit:]]{4})-([[:digit:]]{2})-([[:digit:]]{2})$";
            unstableVersionInNixFormat = parsed != null; # heuristics
            date = builtins.concatStringsSep "" parsed;
            time = "0"; # unstable version in nix format lacks this info
          in
          if unstableVersionInNixFormat then date + "." + time else finalAttrs.version
        );

      preUnpack = ''
        mkdir -p "$NIX_BUILD_TOP/recipes"
        recipeFile="$NIX_BUILD_TOP/recipes/$ename"
        if [ -r "$recipe" ]; then
          ln -s "$recipe" "$recipeFile"
          nixInfoLog "link recipe"
        elif [ -n "$recipe" ]; then
          printf "%s" "$recipe" > "$recipeFile"
          nixInfoLog "write recipe"
        else
          cat > "$recipeFile" <<'EOF'
        (${finalAttrs.ename} :fetcher git :url "" ${
          lib.optionalString (finalAttrs.files != null) ":files ${finalAttrs.files}"
        })
        EOF
          nixInfoLog "use default recipe"
        fi
        nixInfoLog "recipe content:" "$(< $recipeFile)"
        unset -v recipeFile

        ln -s "$packageBuild" "$NIX_BUILD_TOP/package-build"

        mkdir -p "$NIX_BUILD_TOP/packages"
      ''
      + preUnpack;

      postUnpack = ''
        mkdir -p "$NIX_BUILD_TOP/working"
        ln -s "$NIX_BUILD_TOP/$sourceRoot" "$NIX_BUILD_TOP/working/$ename"
      ''
      + postUnpack;

      buildPhase =
        args.buildPhase or ''
          runHook preBuild

          # This is modified from stdenv buildPhase. foundMakefile is used in stdenv checkPhase.
          if [[ ! ( -z "''${makeFlags-}" && -z "''${makefile:-}" && ! ( -e Makefile || -e makefile || -e GNUmakefile ) ) ]]; then
            foundMakefile=1
          fi

          pushd "$NIX_BUILD_TOP"

          emacs --batch -Q \
              -L "$NIX_BUILD_TOP/package-build" \
              -l "$melpa2nix" \
              -f melpa2nix-build-package \
              $ename $melpaVersion $commit

          popd

          runHook postBuild
        '';

      installPhase =
        args.installPhase or ''
          runHook preInstall

          archive="$NIX_BUILD_TOP/packages/$ename-$melpaVersion.el"
          if [ ! -f "$archive" ]; then
              archive="$NIX_BUILD_TOP/packages/$ename-$melpaVersion.tar"
          fi

          emacs --batch -Q \
              -l "$elpa2nix" \
              -f elpa2nix-install-package \
              "$archive" "$out/share/emacs/site-lisp/elpa" \
              ${if finalAttrs.turnCompilationWarningToError then "t" else "nil"} \
              ${if finalAttrs.ignoreCompilationError then "t" else "nil"}

          runHook postInstall
        '';

      meta = {
        homepage = args.src.meta.homepage or "https://melpa.org/#/${pname}";
      }
      // meta;
    };

}
