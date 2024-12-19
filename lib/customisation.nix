{ lib }:

let
  inherit (builtins)
    intersectAttrs;
  inherit (lib)
    functionArgs isFunction mirrorFunctionArgs isAttrs setFunctionArgs
    optionalAttrs attrNames filter elemAt concatStringsSep sortOn take length
    filterAttrs optionalString flip pathIsDirectory head pipe isDerivation listToAttrs
    mapAttrs seq flatten deepSeq warnIf isInOldestRelease extends
    ;
  inherit (lib.strings) levenshtein levenshteinAtMost;

in
rec {


  /**
    `overrideDerivation drv f` takes a derivation (i.e., the result
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


    # Inputs

    `drv`

    : 1\. Function argument

    `f`

    : 2\. Function argument

    # Type

    ```
    overrideDerivation :: Derivation -> ( Derivation -> AttrSet ) -> Derivation
    ```

    # Examples
    :::{.example}
    ## `lib.customisation.overrideDerivation` usage example

    ```nix
    mySed = overrideDerivation pkgs.gnused (oldAttrs: {
      name = "sed-4.2.2-pre";
      src = fetchurl {
        url = ftp://alpha.gnu.org/gnu/sed/sed-4.2.2-pre.tar.bz2;
        hash = "sha256-MxBJRcM2rYzQYwJ5XKxhXTQByvSg5jZc5cSHEZoB2IY=";
      };
      patches = [];
    });
    ```

    :::
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


  /**
    `makeOverridable` takes a function from attribute set to attribute set and
    injects `override` attribute which can be used to override arguments of
    the function.

    Please refer to  documentation on [`<pkg>.overrideDerivation`](#sec-pkg-overrideDerivation) to learn about `overrideDerivation` and caveats
    related to its use.


    # Inputs

    `f`

    : 1\. Function argument

    # Type

    ```
    makeOverridable :: (AttrSet -> a) -> AttrSet -> a
    ```

    # Examples
    :::{.example}
    ## `lib.customisation.makeOverridable` usage example

    ```nix
    nix-repl> x = {a, b}: { result = a + b; }

    nix-repl> y = lib.makeOverridable x { a = 1; b = 2; }

    nix-repl> y
    { override = «lambda»; overrideDerivation = «lambda»; result = 3; }

    nix-repl> y.override { a = 10; }
    { override = «lambda»; overrideDerivation = «lambda»; result = 12; }
    ```

    :::
  */
  makeOverridable = f:
    let
      # Creates a functor with the same arguments as f
      mirrorArgs = mirrorFunctionArgs f;
    in
    mirrorArgs (origArgs:
    let
      result = f origArgs;

      # Changes the original arguments with (potentially a function that returns) a set of new attributes
      overrideWith = newArgs: origArgs // (if isFunction newArgs then newArgs origArgs else newArgs);

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


  /**
    Call the package function in the file `fn` with the required
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


    # Inputs

    `autoArgs`

    : 1\. Function argument

    `fn`

    : 2\. Function argument

    `args`

    : 3\. Function argument

    # Type

    ```
    callPackageWith :: AttrSet -> ((AttrSet -> a) | Path) -> AttrSet -> a
    ```
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
        (sortOn (levenshtein arg))
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
       # This needs to be an abort so it can't be caught with `builtins.tryEval`,
       # which is used by nix-env and ofborg to filter out packages that don't evaluate.
       # This way we're forced to fix such errors in Nixpkgs,
       # which is especially relevant with allowAliases = false
       else abort "lib.customisation.callPackageWith: ${error}";


  /**
    Like callPackage, but for a function that returns an attribute
    set of derivations. The override function is added to the
    individual attributes.


    # Inputs

    `autoArgs`

    : 1\. Function argument

    `fn`

    : 2\. Function argument

    `args`

    : 3\. Function argument

    # Type

    ```
    callPackagesWith :: AttrSet -> ((AttrSet -> AttrSet) | Path) -> AttrSet -> AttrSet
    ```
  */
  callPackagesWith = autoArgs: fn: args:
    let
      f = if isFunction fn then fn else import fn;
      auto = intersectAttrs (functionArgs f) autoArgs;
      mirrorArgs = mirrorFunctionArgs f;
      origArgs = auto // args;
      pkgs = f origArgs;
      mkAttrOverridable = name: _: makeOverridable (mirrorArgs (newArgs: (f newArgs).${name})) origArgs;
    in
      if isDerivation pkgs then throw
        ("function `callPackages` was called on a *single* derivation "
          + ''"${pkgs.name or "<unknown-name>"}";''
          + " did you mean to use `callPackage` instead?")
      else mapAttrs mkAttrOverridable pkgs;


  /**
    Add attributes to each output of a derivation without changing
    the derivation itself and check a given condition when evaluating.


    # Inputs

    `condition`

    : 1\. Function argument

    `passthru`

    : 2\. Function argument

    `drv`

    : 3\. Function argument

    # Type

    ```
    extendDerivation :: Bool -> Any -> Derivation -> Derivation
    ```
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

  /**
    Strip a derivation of all non-essential attributes, returning
    only those needed by hydra-eval-jobs. Also strictly evaluate the
    result to ensure that there are no thunks kept alive to prevent
    garbage collection.


    # Inputs

    `drv`

    : 1\. Function argument

    # Type

    ```
    hydraJob :: (Derivation | Null) -> (Derivation | Null)
    ```
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

  /**
    Make an attribute set (a "scope") from functions that take arguments from that same attribute set.
    See [](#ex-makeScope) for how to use it.

    # Inputs

    1. `newScope` (`AttrSet -> ((AttrSet -> a) | Path) -> AttrSet -> a`)

       A function that takes an attribute set `attrs` and returns what ends up as `callPackage` in the output.

       Typical values are `callPackageWith` or the output attribute `newScope`.

    2. `f` (`AttrSet -> AttrSet`)

       A function that takes an attribute set as returned by `makeScope newScope f` (a "scope") and returns any attribute set.

       This function is used to compute the fixpoint of the resulting scope using `callPackage`.
       Its argument is the lazily evaluated reference to the value of that fixpoint, and is typically called `self` or `final`.

       See [](#ex-makeScope) for how to use it.
       See [](#sec-functions-library-fixedPoints) for details on fixpoint computation.

    # Output

    `makeScope` returns an attribute set of a form called `scope`, which also contains the final attributes produced by `f`:

    ```
    scope :: {
      callPackage :: ((AttrSet -> a) | Path) -> AttrSet -> a
      newScope = AttrSet -> scope
      overrideScope = (scope -> scope -> AttrSet) -> scope
      packages :: AttrSet -> AttrSet
    }
    ```

    - `callPackage` (`((AttrSet -> a) | Path) -> AttrSet -> a`)

      A function that

      1. Takes a function `p`, or a path to a Nix file that contains a function `p`, which takes an attribute set and returns value of arbitrary type `a`,
      2. Takes an attribute set `args` with explicit attributes to pass to `p`,
      3. Calls `f` with attributes from the original attribute set `attrs` passed to `newScope` updated with `args`, i.e. `attrs // args`, if they match the attributes in the argument of `p`.

      All such functions `p` will be called with the same value for `attrs`.

      See [](#ex-makeScope-callPackage) for how to use it.

    - `newScope` (`AttrSet -> scope`)

      Takes an attribute set `attrs` and returns a scope that extends the original scope.

    - `overrideScope` (`(scope -> scope -> AttrSet) -> scope`)

      Takes a function `g` of the form `final: prev: { # attributes }` to act as an overlay on `f`, and returns a new scope with values determined by `extends g f`.
      See [](https://nixos.org/manual/nixpkgs/unstable/#function-library-lib.fixedPoints.extends) for details.

      This allows subsequent modification of the final attribute set in a consistent way, i.e. all functions `p` invoked with `callPackage` will be called with the modified values.

    - `packages` (`AttrSet -> AttrSet`)

      The value of the argument `f` to `makeScope`.

    - final attributes

      The final values returned by `f`.

    # Examples

    :::{#ex-makeScope .example}
    # Create an interdependent package set on top of `pkgs`

    The functions in `foo.nix` and `bar.nix` can depend on each other, in the sense that `foo.nix` can contain a function that expects `bar` as an attribute in its argument.

    ```nix
    let
      pkgs = import <nixpkgs> { };
    in
    pkgs.lib.makeScope pkgs.newScope (self: {
      foo = self.callPackage ./foo.nix { };
      bar = self.callPackage ./bar.nix { };
    })
    ```

    evaluates to

    ```nix
    {
      callPackage = «lambda»;
      newScope = «lambda»;
      overrideScope = «lambda»;
      packages = «lambda»;
      foo = «derivation»;
      bar = «derivation»;
    }
    ```
    :::

    :::{#ex-makeScope-callPackage .example}
    # Using `callPackage` from a scope

    ```nix
    let
      pkgs = import <nixpkgs> { };
      inherit (pkgs) lib;
      scope = lib.makeScope lib.callPackageWith (self: { a = 1; b = 2; });
      three = scope.callPackage ({ a, b }: a + b) { };
      four = scope.callPackage ({ a, b }: a + b) { a = 2; };
    in
    [ three four ]
    ```

    evaluates to

    ```nix
    [ 3 4 ]
    ```
    :::

    # Type

    ```
    makeScope :: (AttrSet -> ((AttrSet -> a) | Path) -> AttrSet -> a) -> (AttrSet -> AttrSet) -> scope
    ```
  */
  makeScope = newScope: f:
    let self = f self // {
          newScope = scope: newScope (self // scope);
          callPackage = self.newScope {};
          overrideScope = g: makeScope newScope (extends g f);
          packages = f;
        };
    in self;

  /**
    backward compatibility with old uncurried form; deprecated


    # Inputs

    `splicePackages`

    : 1\. Function argument

    `newScope`

    : 2\. Function argument

    `otherSplices`

    : 3\. Function argument

    `keep`

    : 4\. Function argument

    `extra`

    : 5\. Function argument

    `f`

    : 6\. Function argument
  */
  makeScopeWithSplicing =
    splicePackages: newScope: otherSplices: keep: extra: f:
    makeScopeWithSplicing'
    { inherit splicePackages newScope; }
    { inherit otherSplices keep extra f; };

  /**
    Like makeScope, but aims to support cross compilation. It's still ugly, but
    hopefully it helps a little bit.

    # Type

    ```
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
    ```
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

}
