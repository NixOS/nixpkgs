{ lib }:

let
  inherit (builtins)
    intersectAttrs;
  inherit (lib)
    functionArgs isFunction mirrorFunctionArgs isAttrs setFunctionArgs
    optionalAttrs attrNames filter elemAt concatStringsSep sort take length
    filterAttrs optionalString flip pathIsDirectory head pipe isDerivation listToAttrs
    mapAttrs seq flatten deepSeq warnIf isInOldestRelease extends
    toFunction
    ;
  inherit (lib.strings) levenshtein levenshteinAtMost;

in
rec {


  /* `overrideDerivation drv f` takes a derivation (i.e., the result
     of a call to the builtin function `derivation`) and returns a new
     derivation in which the attributes of the original are overridden
     according to the function `f`.  The function `f` is called with
     the original derivation attributes.

     `overrideDerivation` allows certain "ad-hoc" customisation
     scenarios (e.g. in ~/.config/nixpkgs/config.nix).  For instance,
     if you want to "patch" the derivation returned by a package
     function in Nixpkgs to build another version than what the
     function itself provides.

     For another application, see build-support/vm, where this
     function is used to build arbitrary derivations inside a QEMU
     virtual machine.

     Note that in order to preserve evaluation errors, the new derivation's
     outPath depends on the old one's, which means that this function cannot
     be used in circular situations when the old derivation also depends on the
     new one.

     You should in general prefer `drv.overrideAttrs` over this function;
     see the nixpkgs manual for more information on overriding.

     Example:
       mySed = overrideDerivation pkgs.gnused (oldAttrs: {
         name = "sed-4.2.2-pre";
         src = fetchurl {
           url = ftp://alpha.gnu.org/gnu/sed/sed-4.2.2-pre.tar.bz2;
           hash = "sha256-MxBJRcM2rYzQYwJ5XKxhXTQByvSg5jZc5cSHEZoB2IY=";
         };
         patches = [];
       });

     Type:
       overrideDerivation :: Derivation -> ( Derivation -> AttrSet ) -> Derivation
  */
  overrideDerivation = drv: f:
    let
      newDrv = derivation (drv.drvAttrs // (f drv));
    in flip (extendDerivation (seq drv.drvPath true)) newDrv (
      { meta = drv.meta or {};
        passthru = if drv ? passthru then drv.passthru else {};
      }
      //
      (drv.passthru or {})
      //
      optionalAttrs (drv ? __spliced) {
        __spliced = {} // (mapAttrs (_: sDrv: overrideDerivation sDrv f) drv.__spliced);
      });


  /* `makeOverridable` takes a function from attribute set to attribute set and
     injects `override` attribute which can be used to override arguments of
     the function.

     Aside from attrset-to-attrset function decoration, `makeOverridable`
     can also decorate a fixed-point-function-to-attrset function, such as
     build helpers with fixed-point arguments.

     Please refer to  documentation on [`<pkg>.overrideDerivation`](#sec-pkg-overrideDerivation) to learn about `overrideDerivation` and caveats
     related to its use.

     Example:
       nix-repl> x1 = {a, b}: { result = a + b; }

       nix-repl> y1 = lib.makeOverridable x1 { a = 1; b = 2; }

       nix-repl> y1
       { override = «lambda»; overrideDerivation = «lambda»; result = 3; }

       nix-repl> y1.override { a = 10; }
       { override = «lambda»; overrideDerivation = «lambda»; result = 12; }

       nix-repl> x2 = fpargs: lib.fix (lib.extends (finalAttrs: {a, b}: {result = a + b; }) fpargs)

       nix-repl> x2 (finalAttrs: { a = 1; b = 2; })
       { a = 1; b = 2; result = 3; }

       nix-repl> y2 = lib.makeOverridable x2 (finalAttrs: { a = 1; b = 2; })

       nix-repl> y2
       { override = «lambda»; overrideDerivation = «lambda»; result = 3; }

       nix-repl> y2.override (finalAttrs: { a = 10; })
       { override = «lambda»; overrideDerivation = «lambda»; result = 12; }

     Type:
       makeOverridable ::
         ((AttrSet | (AttrSet -> AttrSet)) -> a)
         -> (AttrSet | (AttrSet -> AttrSet)) -> a
  */
  makeOverridable = f:
    let
      # Creates a functor with the same arguments as f
      mirrorArgs = mirrorFunctionArgs f;
    in
    mirrorArgs (origArgs:
    let
      result = f origArgs;

      # Changes the original arguments with (potentially a function that returns) a set of new attributes.
      #
      # When newArgs is a plain set, it overrides to the original argument set directly.
      # If newArgs is a function (AttrSet -> AttrSet), it is applied to the original argument set.
      # If origArgs is a function (AttrSet -> AttrSet) instead of a set, generate a new function from origArgs
      # with newArgs apply to its resulting attribute set.
      overrideWithRecursive = newArgs: finalAttrs:
      let
        origArgsFixed = toFunction origArgs finalAttrs;
      in
      origArgsFixed // toFunction newArgs origArgsFixed;
      overrideWith = if isFunction origArgs then overrideWithRecursive else (flip overrideWithRecursive null);

      # Re-call the function but with different arguments
      overrideArgs = mirrorArgs (newArgs: makeOverridable f (overrideWith newArgs));
      # Change the result of the function call by applying g to it
      overrideResult = g: makeOverridable (mirrorArgs (args: g (f args))) origArgs;
    in
      if isAttrs result then
        result // {
          override = overrideArgs;
          overrideDerivation = fdrv: overrideResult (x: overrideDerivation x fdrv);
          ${if result ? overrideAttrs then "overrideAttrs" else null} = fdrv:
            overrideResult (x: x.overrideAttrs fdrv);
        }
      else if isFunction result then
        # Transform the result into a functor while propagating its arguments
        setFunctionArgs result (functionArgs result) // {
          override = overrideArgs;
        }
      else result);


  /* Call the package function in the file `fn` with the required
    arguments automatically.  The function is called with the
    arguments `args`, but any missing arguments are obtained from
    `autoArgs`.  This function is intended to be partially
    parameterised, e.g.,

      ```nix
      callPackage = callPackageWith pkgs;
      pkgs = {
        libfoo = callPackage ./foo.nix { };
        libbar = callPackage ./bar.nix { };
      };
      ```

    If the `libbar` function expects an argument named `libfoo`, it is
    automatically passed as an argument.  Overrides or missing
    arguments can be supplied in `args`, e.g.

      ```nix
      libbar = callPackage ./bar.nix {
        libfoo = null;
        enableX11 = true;
      };
      ```

    <!-- TODO: Apply "Example:" tag to the examples above -->

    Type:
      callPackageWith :: AttrSet -> ((AttrSet -> a) | Path) -> AttrSet -> a
  */
  callPackageWith = autoArgs: fn: args:
    let
      f = if isFunction fn then fn else import fn;
      fargs = functionArgs f;

      # All arguments that will be passed to the function
      # This includes automatic ones and ones passed explicitly
      allArgs = intersectAttrs fargs autoArgs // args;

      # a list of argument names that the function requires, but
      # wouldn't be passed to it
      missingArgs =
        # Filter out arguments that have a default value
        (filterAttrs (name: value: ! value)
        # Filter out arguments that would be passed
        (removeAttrs fargs (attrNames allArgs)));

      # Get a list of suggested argument names for a given missing one
      getSuggestions = arg: pipe (autoArgs // args) [
        attrNames
        # Only use ones that are at most 2 edits away. While mork would work,
        # levenshteinAtMost is only fast for 2 or less.
        (filter (levenshteinAtMost 2 arg))
        # Put strings with shorter distance first
        (sort (x: y: levenshtein x arg < levenshtein y arg))
        # Only take the first couple results
        (take 3)
        # Quote all entries
        (map (x: "\"" + x + "\""))
      ];

      prettySuggestions = suggestions:
        if suggestions == [] then ""
        else if length suggestions == 1 then ", did you mean ${elemAt suggestions 0}?"
        else ", did you mean ${concatStringsSep ", " (lib.init suggestions)} or ${lib.last suggestions}?";

      errorForArg = arg:
        let
          loc = builtins.unsafeGetAttrPos arg fargs;
          # loc' can be removed once lib/minver.nix is >2.3.4, since that includes
          # https://github.com/NixOS/nix/pull/3468 which makes loc be non-null
          loc' = if loc != null then loc.file + ":" + toString loc.line
            else if ! isFunction fn then
              toString fn + optionalString (pathIsDirectory fn) "/default.nix"
            else "<unknown location>";
        in "Function called without required argument \"${arg}\" at "
        + "${loc'}${prettySuggestions (getSuggestions arg)}";

      # Only show the error for the first missing argument
      error = errorForArg (head (attrNames missingArgs));

    in if missingArgs == {}
       then makeOverridable f allArgs
       else throw "lib.customisation.callPackageWith: ${error}";


  /* Like callPackage, but for a function that returns an attribute
     set of derivations. The override function is added to the
     individual attributes.

     Type:
       callPackagesWith :: AttrSet -> ((AttrSet -> AttrSet) | Path) -> AttrSet -> AttrSet
  */
  callPackagesWith = autoArgs: fn: args:
    let
      f = if isFunction fn then fn else import fn;
      auto = intersectAttrs (functionArgs f) autoArgs;
      origArgs = auto // args;
      pkgs = f origArgs;
      mkAttrOverridable = name: _: makeOverridable (newArgs: (f newArgs).${name}) origArgs;
    in
      if isDerivation pkgs then throw
        ("function `callPackages` was called on a *single* derivation "
          + ''"${pkgs.name or "<unknown-name>"}";''
          + " did you mean to use `callPackage` instead?")
      else mapAttrs mkAttrOverridable pkgs;


  /* Add attributes to each output of a derivation without changing
     the derivation itself and check a given condition when evaluating.

     Type:
       extendDerivation :: Bool -> Any -> Derivation -> Derivation
  */
  extendDerivation = condition: passthru: drv:
    let
      outputs = drv.outputs or [ "out" ];

      commonAttrs = drv // (listToAttrs outputsList) //
        ({ all = map (x: x.value) outputsList; }) // passthru;

      outputToAttrListElement = outputName:
        { name = outputName;
          value = commonAttrs // {
            inherit (drv.${outputName}) type outputName;
            outputSpecified = true;
            drvPath = assert condition; drv.${outputName}.drvPath;
            outPath = assert condition; drv.${outputName}.outPath;
          } //
            # TODO: give the derivation control over the outputs.
            #       `overrideAttrs` may not be the only attribute that needs
            #       updating when switching outputs.
            optionalAttrs (passthru?overrideAttrs) {
              # TODO: also add overrideAttrs when overrideAttrs is not custom, e.g. when not splicing.
              overrideAttrs = f: (passthru.overrideAttrs f).${outputName};
            };
        };

      outputsList = map outputToAttrListElement outputs;
    in commonAttrs // {
      drvPath = assert condition; drv.drvPath;
      outPath = assert condition; drv.outPath;
    };

  /* Strip a derivation of all non-essential attributes, returning
     only those needed by hydra-eval-jobs. Also strictly evaluate the
     result to ensure that there are no thunks kept alive to prevent
     garbage collection.

     Type:
       hydraJob :: (Derivation | Null) -> (Derivation | Null)
  */
  hydraJob = drv:
    let
      outputs = drv.outputs or ["out"];

      commonAttrs =
        { inherit (drv) name system meta; inherit outputs; }
        // optionalAttrs (drv._hydraAggregate or false) {
          _hydraAggregate = true;
          constituents = map hydraJob (flatten drv.constituents);
        }
        // (listToAttrs outputsList);

      makeOutput = outputName:
        let output = drv.${outputName}; in
        { name = outputName;
          value = commonAttrs // {
            outPath = output.outPath;
            drvPath = output.drvPath;
            type = "derivation";
            inherit outputName;
          };
        };

      outputsList = map makeOutput outputs;

      drv' = (head outputsList).value;
    in if drv == null then null else
      deepSeq drv' drv';

  /* Make a set of packages with a common scope. All packages called
     with the provided `callPackage` will be evaluated with the same
     arguments. Any package in the set may depend on any other. The
     `overrideScope'` function allows subsequent modification of the package
     set in a consistent way, i.e. all packages in the set will be
     called with the overridden packages. The package sets may be
     hierarchical: the packages in the set are called with the scope
     provided by `newScope` and the set provides a `newScope` attribute
     which can form the parent scope for later package sets.

     Type:
       makeScope :: (AttrSet -> ((AttrSet -> a) | Path) -> AttrSet -> a) -> (AttrSet -> AttrSet) -> AttrSet
  */
  makeScope = newScope: f:
    let self = f self // {
          newScope = scope: newScope (self // scope);
          callPackage = self.newScope {};
          overrideScope = g: makeScope newScope (extends g f);
          # Remove after 24.11 is released.
          overrideScope' = g: warnIf (isInOldestRelease 2311)
            "`overrideScope'` (from `lib.makeScope`) has been renamed to `overrideScope`."
            (makeScope newScope (extends g f));
          packages = f;
        };
    in self;

  /* backward compatibility with old uncurried form; deprecated */
  makeScopeWithSplicing =
    splicePackages: newScope: otherSplices: keep: extra: f:
    makeScopeWithSplicing'
    { inherit splicePackages newScope; }
    { inherit otherSplices keep extra f; };

  /* Like makeScope, but aims to support cross compilation. It's still ugly, but
     hopefully it helps a little bit.

     Type:
       makeScopeWithSplicing' ::
         { splicePackages :: Splice -> AttrSet
         , newScope :: AttrSet -> ((AttrSet -> a) | Path) -> AttrSet -> a
         }
         -> { otherSplices :: Splice, keep :: AttrSet -> AttrSet, extra :: AttrSet -> AttrSet }
         -> AttrSet

       Splice ::
         { pkgsBuildBuild :: AttrSet
         , pkgsBuildHost :: AttrSet
         , pkgsBuildTarget :: AttrSet
         , pkgsHostHost :: AttrSet
         , pkgsHostTarget :: AttrSet
         , pkgsTargetTarget :: AttrSet
         }
  */
  makeScopeWithSplicing' =
    { splicePackages
    , newScope
    }:
    { otherSplices
    # Attrs from `self` which won't be spliced.
    # Avoid using keep, it's only used for a python hook workaround, added in PR #104201.
    # ex: `keep = (self: { inherit (self) aAttr; })`
    , keep ? (_self: {})
    # Additional attrs to add to the sets `callPackage`.
    # When the package is from a subset (but not a subset within a package IS #211340)
    # within `spliced0` it will be spliced.
    # When using an package outside the set but it's available from `pkgs`, use the package from `pkgs.__splicedPackages`.
    # If the package is not available within the set or in `pkgs`, such as a package in a let binding, it will not be spliced
    # ex:
    # ```
    # nix-repl> darwin.apple_sdk.frameworks.CoreFoundation
    #   «derivation ...CoreFoundation-11.0.0.drv»
    # nix-repl> darwin.CoreFoundation
    #   error: attribute 'CoreFoundation' missing
    # nix-repl> darwin.callPackage ({ CoreFoundation }: CoreFoundation) { }
    #   «derivation ...CoreFoundation-11.0.0.drv»
    # ```
    , extra ? (_spliced0: {})
    , f
    }:
    let
      spliced0 = splicePackages {
        pkgsBuildBuild = otherSplices.selfBuildBuild;
        pkgsBuildHost = otherSplices.selfBuildHost;
        pkgsBuildTarget = otherSplices.selfBuildTarget;
        pkgsHostHost = otherSplices.selfHostHost;
        pkgsHostTarget = self; # Not `otherSplices.selfHostTarget`;
        pkgsTargetTarget = otherSplices.selfTargetTarget;
      };
      spliced = extra spliced0 // spliced0 // keep self;
      self = f self // {
        newScope = scope: newScope (spliced // scope);
        callPackage = newScope spliced; # == self.newScope {};
        # N.B. the other stages of the package set spliced in are *not*
        # overridden.
        overrideScope = g: (makeScopeWithSplicing'
          { inherit splicePackages newScope; }
          { inherit otherSplices keep extra;
            f = extends g f;
          });
        packages = f;
      };
    in self;

  /*
    Define a `mkDerivation`-like function based on another `mkDerivation`-like function.

    `mkDerivation` gives access to its final set of derivation attributes when
    it is passed a function, or when it is passed an overlay-style function in
    `overrideAttrs`.

    Instead of composing new `mkDerivation`-like build helpers using normal
    function composition, `extendMkDerivation` makes sure that the returned
    build helper supports such first class recursion like `mkDerivation` does.

    the base build helper by changing the input arguments. The choice of the
    base build helper must be `finalAttrs`-independent. In most cases,
    *getMkDerivationBase* is simply a constant function that returns the base
    build helper.

    This functions are mainly about defining build helpers (`a == Derivation`),
    but is flexible enough to handle return types other than derivation.

    Type:
      extendMkDerivation ::
        (FixedPointArgs -> (FixedPointArgs | AttrSet) -> a)
        -> (AttrSet -> AttrSet -> AttrSet)
        -> (FixedPointArgs | AttrSet) -> a

      FixedPointArgs :: AttrSet -> AttrSet

    Example:
      mkLocalDerivation = lib.extendMkDerivation pkgs.stdenv.mkDerivation (finalAttrs:
        args@{ preferLocalBuild ? true, allowSubstitute ? false, impassablePredicate ? (_: false), ... }:
        removeAttrs args [ "impassablePredicate" ] // { inherit preferLocalBuild allowSubstitute; })

      mkLocalDerivation.__functionArgs
      => { allowSubstitute = true; impassablePredicate = true; preferLocalBuild = true; }

      mkLocalDerivation { inherit (pkgs.hello) pname version src; impassablePredicate = _: false; }
      => «derivation /nix/store/xirl67m60ahg6jmzicx43a81g635g8z8-hello-2.12.1.drv»

      mkLocalDerivation (finalAttrs: { inherit (pkgs.hello) pname version src; impassablePredicate = _: false; })
      => «derivation /nix/store/xirl67m60ahg6jmzicx43a81g635g8z8-hello-2.12.1.drv»

      (mkLocalDerivation (finalAttrs: { inherit (pkgs.hello) pname version src; passthru = { foo = "a"; bar = "${finalAttrs.passthru.foo}b"; } })).bar
      => "ab"
  */
  extendMkDerivation =
    # mkDerivation-like build helper to extend
    mkDerivationBase:
    # Overlay implementation of the new build helper
    impl:
    mirrorFunctionArgs
      # Make the __functionArgs looks like one from a build helper accepting plain attribute set.
      (impl { })
      # Adds the fixed-point style support
      (fpargs: mkDerivationBase (finalAttrs:
        impl finalAttrs (if isFunction fpargs then fpargs finalAttrs else fpargs)
      ));


  /*
    Like `extendMkDerivation`, but additionally accepts a function
    to be applied to the result derivation.

    :::{.note}
    The derivation modification function *modify* should take care of
    existing attributes that performs overriding (e.g. `<pkg>.overrideAttrs`),
    to make the overriding functionality of the result derivation work
    as expected.

    Modifications that does not respect such attributes include
    direct [attribute set update](https://nixos.org/manual/nix/stable/language/operators#update)
    and [`lib.extendDerivation`](#function-library-lib.customisation.extendDerivation).
    :::

    Type:
      extendMkDerivation ::
        ((AttrSet -> AttrSet) -> a)
        -> (a -> a)
        -> (AttrSet -> { <b_i> } -> AttrSet)
        -> ((AttrSet -> { <b_i> }) | { <b_i> }) -> a
  */
  extendMkDerivationModified =
    # Function to modify the resulting derivation
    modify:
    # Function to get the mkDerivation-like build helper to extend
    # from the input arguments fixed with an empty attribute set.
    getMkDerivationBase:
    # Overlay implementation of the new build helper
    impl:
    mirrorFunctionArgs
      # Make the __functionArgs looks like one from a build helper accepting plain attribute set.
      (impl { })
      (rattr: modify (extendMkDerivation getMkDerivationBase impl rattr));
}
