{ lib }:

let
  inherit (builtins)
    intersectAttrs;
  inherit (lib)
    functionArgs isFunction mirrorFunctionArgs isAttrs setFunctionArgs levenshteinAtMost
    optionalAttrs attrNames levenshtein filter elemAt concatStringsSep sort take length
    filterAttrs optionalString flip pathIsDirectory head pipe isDerivation listToAttrs
    mapAttrs seq flatten deepSeq warnIf isInOldestRelease extends intersectLists genAttrs
    id;

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

     Please refer to  documentation on [`<pkg>.overrideDerivation`](#sec-pkg-overrideDerivation) to learn about `overrideDerivation` and caveats
     related to its use.

     Example:
       nix-repl> x = {a, b}: { result = a + b; }

       nix-repl> y = lib.makeOverridable x { a = 1; b = 2; }

       nix-repl> y
       { override = «lambda»; overrideDerivation = «lambda»; result = 3; }

       nix-repl> y.override { a = 10; }
       { override = «lambda»; overrideDerivation = «lambda»; result = 12; }

     Type:
       makeOverridable :: (AttrSet -> a) -> AttrSet -> a
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
      error = errorForArg missingArgs.${head (attrNames missingArgs)};

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


  /*
    Add attributes to each output of a derivation without changing
    the derivation itself and check a given condition when evaluating.

    :::{.note}
    This function isn't aware of any existing overrider (e.g.
    <pkg>.overrideAttrs or <pkg>.override), and is only suitable for
    low-level usage, such as the definiton of `stdenv.mkDerivation`
    and `lib.makeOverridable`.

    Use `extendDerivation'` instead in most other cases.
    :::

    Type:
      extendDerivation :: Bool -> AttrSet -> Derivation -> Derivation

    Example:
      pkgs.hello
      => «derivation /nix/store/nvl9ic0pj1fpyln3zaqrf4cclbqdfn1j-hello-2.12.1.drv»

      helloWithAns = lib.extendDerivation true { ans = 42; } pkgs.hello

      helloWithAns
      => «derivation /nix/store/nvl9ic0pj1fpyln3zaqrf4cclbqdfn1j-hello-2.12.1.drv»

      helloWithAns.ans
      => 42

      helloWithAns.out.ans
      => 42

      helloFive = lib.extendDerivation ((2 + 2 == 5) || builtins.trace "2 + 2 != 5" false) { } pkgs.hello

      helloFive
      => trace: 2 + 2 != 5
      => error: assertion 'condition' failed
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

  /*
    Alternative to lib.extendDerivation that takes care of existing
    overriders.

    Derivations often comes with attributes that performs overriding
    (referred to as "overriders" here). The argument *overriderNames*
    specifies all possible names of all such attribuets of the
    input derivation or its derivation outputs, or in the *passthru*
    input argument.

    The boolean argument *keepOverriders* specifies if `extendDerivation'`
    should update existing overriders from the input derivation and its outputs
    to automatically re-apply the changes to the future overriding results.
    When set to `false`, one need to update all overriders themself.

    Set *keepOverriders* to `false` allows one to pass overriders through the
    *passthru* input argument. For custom overrider definition, it also help to
    specify *overriderNames* to include the names of all overriders, including
    the custom ones.

    The boolean argument *spreadOverriders* specifies if `extendDerivation'`
    should attach overriders from the derivation to each output, but decorate them
    to return the specfic output of the override result.
    Setting it to `true` requires *keepOverriders* be `true`.

    Type:
      extendDerivation' ::
        { condition :: Bool
        , passthru :: AttrSet
        , overriderNames :: [ String ]
        , keepOverriders :: Bool
        , spreadOverriders :: Bool
        }
        -> Derivation -> Derivation

    Example:
      helloWithAns0 = lib.extendDerivation true { ans = 42; } pkgs.hello

      (helloWithAns0.overrideAttrs { }).ans
      => error: attribute 'ans' missing

      helloWithAns1 = lib.extendDerivation' {
        keepOverridable = false;
        passthru = { ans = 42; };
      } pkgs.hello

      (helloWithAns1.overrideAttrs { }).ans
      => error: attribute 'ans' missing

      helloWithAns2 = lib.extendDerivation' {
        passthru = { ans = 42; };
      } pkgs.hello

      (helloWithAns2.overrideAttrs { }).ans
      => 42

      (helloWithAns2.override { }).ans
      => 42

      pkgs.cpio.dev.outputName
      => "dev"

      pkgs.cpio.dev.overrideAttrs
      => «lambda»

      (pkgs.cpio.dev.overrideAttrs { }).outputName
      => "dev"

      ((lib.extendDerivation true { } cpio).dev.overrideAttrs { }).outputName
      => "out"

      (lib.extendDerivation' { keepOverriders = false; } cpio).dev.overrideAttrs
      => error: attribute 'overrideAttrs' missing

      (lib.extendDerivation' { } cpio).dev.overrideAttrs
      => «lambda»

      ((lib.extendDerivation' { } cpio).dev.overrideAttrs { }).outputName
      => "dev"

      pkgs.cpio.override
      => «lambda»

      pkgs.cpio.dev.override
      => error: attribute 'override' missing

      (lib.extendDerivation' {
        spreadOverriders = true;
      } pkgs.cpio).dev.override
      => «lambda»

      ((lib.extendDerivation' {
        spreadOverriders = true;
      } pkgs.cpio).dev.override { }).outputName
      => "dev"
  */
  extendDerivation' =
    let
      getExistingAttrs = names: attrs:
        genAttrs (intersectLists (attrNames attrs) names) (name: attrs.${name});
      mirrorFunctionArgs' =
        f:
        let
          fArgs = functionArgs f;
        in
        if (fArgs != { }) then
        (g: setFunctionArgs g fArgs)
        else id;
    in
    { condition ? true
    , passthru ? { }
    , overriderNames ? [ "overrideAttrs" "overrideDerivation" "override" ]
    , keepOverriders ? true
    , spreadOverriders ? false
    }:
    assert (spreadOverriders -> keepOverriders) || throw "spreadOverriders == true requires keepOverriders == true";
    let
      shiftOverriders = outputName: mapAttrs
        (overriderName: overrider: mirrorFunctionArgs'
          overrider
          (fdrv: (overrider fdrv).${outputName})
        );

      # Get a subset of overriders to update the `<pkg>.passthru`, as
      # build helpers may use `<pkg>.passthru` to hold custom overriders,
      # or to monkey-patch existing overriders.
      fixMkDerivationPassthru = passthru: overriders:
        passthru // intersectAttrs passthru overriders;

      fMain = drv:
      let
        outputs = drv.outputs or [ "out" ];
        overriders = genAttrs
          (intersectLists (attrNames drv) overriderNames)
          (overriderName: mirrorFunctionArgs' drv.${overriderName}
            (fdrv: fMain (drv.${overriderName} fdrv))
          );
      in
      drv // passthru // {
        drvPath = assert condition; drv.drvPath;
        outPath = assert condition; drv.outPath;
      } // genAttrs outputs (outputName: fOutput {
        outputDrv = drv.${outputName};
        inherit outputName;
        overridersFromMain = optionalAttrs spreadOverriders overriders;
      }) // optionalAttrs keepOverriders overriders
      // optionalAttrs (drv?passthru) {
        passthru = fixMkDerivationPassthru drv.passthru overriders;
      };

      fOutput =
        { outputDrv
        , outputName ? outputDrv.outputName
        , overridersFromMain ? { }
        , outputs ? outputDrv.outputs or [ "out" ]
        }:
        let
          overriders = if keepOverriders
            then mapAttrs (overriderName: overrider:
              mirrorFunctionArgs' overrider (fdrv: fOutput {
                outputDrv = overrider fdrv;
                inherit outputName overridersFromMain outputs;
              })
            ) (shiftOverriders outputName overridersFromMain // getExistingAttrs overriderNames outputDrv)
            else shiftOverriders outputName (getExistingAttrs overriderNames passthru);
        in
        outputDrv // passthru // {
          inherit (outputDrv) type outputName;
          outputSpecified = true;
          inherit outputs;
          drvPath = assert condition; outputDrv.drvPath;
          outPath = assert condition; outputDrv.outPath;
        } // overriders
        // optionalAttrs (outputDrv?passthru) {
          passthru = fixMkDerivationPassthru outputDrv.passthru overriders;
        };
    in
    fMain;

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

}
