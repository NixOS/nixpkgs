let

  lib = import ./default.nix;
  inherit (builtins) attrNames isFunction;

in

rec {


  /* `overrideDerivation drv f' takes a derivation (i.e., the result
     of a call to the builtin function `derivation') and returns a new
     derivation in which the attributes of the original are overridden
     according to the function `f'.  The function `f' is called with
     the original derivation attributes.

     `overrideDerivation' allows certain "ad-hoc" customisation
     scenarios (e.g. in ~/.config/nixpkgs/config.nix).  For instance,
     if you want to "patch" the derivation returned by a package
     function in Nixpkgs to build another version than what the
     function itself provides, you can do something like this:

       mySed = overrideDerivation pkgs.gnused (oldAttrs: {
         name = "sed-4.2.2-pre";
         src = fetchurl {
           url = ftp://alpha.gnu.org/gnu/sed/sed-4.2.2-pre.tar.bz2;
           sha256 = "11nq06d131y4wmf3drm0yk502d2xc6n5qy82cg88rb9nqd2lj41k";
         };
         patches = [];
       });

     For another application, see build-support/vm, where this
     function is used to build arbitrary derivations inside a QEMU
     virtual machine.
  */
  overrideDerivation = drv: f:
    let
      newDrv = derivation (drv.drvAttrs // (f drv));
    in addPassthru newDrv (
      { meta = drv.meta or {};
        passthru = if drv ? passthru then drv.passthru else {};
      }
      //
      (drv.passthru or {})
      //
      (if (drv ? crossDrv && drv ? nativeDrv)
       then {
         crossDrv = overrideDerivation drv.crossDrv f;
         nativeDrv = overrideDerivation drv.nativeDrv f;
       }
       else { }));


  # Like `makeOverridable`, but provides the function with the `self`
  # argument. `f` is called with the new `self` whenever an override
  # or extension is added.
  makeOverridableWithSelf = f: origArgs: let

    interface = {val, args, ...}: overridePackage:
      (lib.optionalAttrs (builtins.isAttrs val) (val // {
        extend = f: overridePackage (self: super: {
          val = super.val // f self.val super.val;
        });

        overrideDerivation = newArgs: overridePackage (self: super: {
          val = lib.overrideDerivation super.val newArgs;
        });
      })) // (lib.optionalAttrs (builtins.isFunction val) {
        __functor = _: val;
        extend = throw "extend not yet supported for functors";
        overrideDerivation = throw "overrideDerivation not yet supported for functors";
      }) // {
        inherit overridePackage;

        override = newArgs: overridePackage (self: super: {
          args = super.args //
            (if builtins.isFunction newArgs then newArgs super.args else newArgs);
        });
      };

  in lib.makeExtensibleWithInterface interface (self: {
    args = origArgs;
    val = f self.args self.val;
  });


  /* `makeOverridable` takes a function from attribute set to
     attribute set and injects 4 attributes which can be used to
     override arguments and return values of the function.


     1. `override` allows you to change what arguments were passed to
     the function and acquire the new result.

       nix-repl> x = {a, b}: { result = a + b; }

       nix-repl> y = lib.makeOverridable x { a = 1; b = 2; }

       nix-repl> y
       { override = «lambda»; overrideDerivation = «lambda»; result = 3; }

       nix-repl> y.override { a = 10; }
       { override = «lambda»; overrideDerivation = «lambda»; result = 12; }


     2. `extend` changes the results of the function, giving you a
     view of the original result and a view of the eventual final
     result. It is meant to do the same thing as
     `makeExtensible`. That is, it lets you add to or change the
     return value, such that previous extensions are consistent with
     the final view, rather than being based on outdated
     values. "Outdated" values come from the `super` argument, which
     must be used when you are attempting to modify and old value. And
     the final values come from the `self` argument, which recursively
     refers to what all extensions combined return.

       nix-repl> obj = makeOverridable (args: { }) { }

       nix-repl> obj = obj.extend (self: super: { foo = "foo"; })

       nix-repl> obj.foo
       "foo"

       nix-repl> obj = obj.extend (self: super: { foo = super.foo + " + "; bar = "bar"; foobar = self.foo + self.bar; })

       nix-repl> obj
       { bar = "bar"; foo = "foo + "; foobar = "foo + bar"; ... } # Excess omitted


     3. `overrideDerivation`: Please refer to "Nixpkgs Contributors
     Guide" section "<pkg>.overrideDerivation" to learn about
     `overrideDerivation` and caveats related to its use.


     4. `overridePackage` is by far the most powerful of the four, as
     it exposes a deeper structure. It provides `self` and `super`
     views of both the arguments and return value of the function,
     allowing you to change both in one override; you can even have
     overrides for one based on overrides for the other. The type of
     `self`, `super`, and the return value are all:
     `{ args :: argumentsToF, val :: returnValueOfF }`

       nix-repl> obj = makeOverridable ({a, b}: {inherit a b;}) {a = 1; b = 3;}

       nix-repl> obj = obj.overridePackage (self: super: { args = super.args // {b = self.val.a;}; })

       nix-repl> obj.b
       1

       nix-repl> obj = obj.overridePackage (self: super: { val = super.val // {a = self.args.a + 10;}; })

       nix-repl> obj.b
       11

  */
  makeOverridable = fn: makeOverridableWithSelf (args: _: fn args);


  /* Call the package function in the file `fn' with the required
    arguments automatically.  The function is called with the
    arguments `args', but any missing arguments are obtained from
    `autoArgs'.  This function is intended to be partially
    parameterised, e.g.,

      callPackage = callPackageWith pkgs;
      pkgs = {
        libfoo = callPackage ./foo.nix { };
        libbar = callPackage ./bar.nix { };
      };

    If the `libbar' function expects an argument named `libfoo', it is
    automatically passed as an argument.  Overrides or missing
    arguments can be supplied in `args', e.g.

      libbar = callPackage ./bar.nix {
        libfoo = null;
        enableX11 = true;
      };
  */
  callPackageWith = autoArgs: fn: args:
    let
      f = if builtins.isFunction fn then fn else import fn;
      auto = builtins.intersectAttrs (builtins.functionArgs f) autoArgs;
    in makeOverridable f (auto // args);


  /* Like callPackage, but for a function that returns an attribute
     set of derivations. The override function is added to the
     individual attributes. */
  callPackagesWith = autoArgs: fn: args:
    let
      f = if builtins.isFunction fn then fn else import fn;
      auto = builtins.intersectAttrs (builtins.functionArgs f) autoArgs;
      origArgs = auto // args;
      pkgs = f origArgs;
      mkAttrOverridable = name: pkg: makeOverridable (newArgs: (f newArgs).${name}) origArgs;
    in lib.mapAttrs mkAttrOverridable pkgs;


  /* Add attributes to each output of a derivation without changing
     the derivation itself. */
  addPassthru = drv: passthru:
    let
      outputs = drv.outputs or [ "out" ];

      commonAttrs = drv // (builtins.listToAttrs outputsList) //
        ({ all = map (x: x.value) outputsList; }) // passthru;

      outputToAttrListElement = outputName:
        { name = outputName;
          value = commonAttrs // {
            inherit (drv.${outputName}) outPath drvPath type outputName;
          };
        };

      outputsList = map outputToAttrListElement outputs;
  in commonAttrs // { outputUnspecified = true; };


  /* Strip a derivation of all non-essential attributes, returning
     only those needed by hydra-eval-jobs. Also strictly evaluate the
     result to ensure that there are no thunks kept alive to prevent
     garbage collection. */
  hydraJob = drv:
    let
      outputs = drv.outputs or ["out"];

      commonAttrs =
        { inherit (drv) name system meta; inherit outputs; }
        // lib.optionalAttrs (drv._hydraAggregate or false) {
          _hydraAggregate = true;
          constituents = map hydraJob (lib.flatten drv.constituents);
        }
        // (lib.listToAttrs outputsList);

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

      drv' = (lib.head outputsList).value;
    in lib.deepSeq drv' drv';

  /* Make a set of packages with a common scope. All packages called
     with the provided `callPackage' will be evaluated with the same
     arguments. Any package in the set may depend on any other. The
     `overrideScope' function allows subsequent modification of the package
     set in a consistent way, i.e. all packages in the set will be
     called with the overridden packages. The package sets may be
     hierarchical: the packages in the set are called with the scope
     provided by `newScope' and the set provides a `newScope' attribute
     which can form the parent scope for later package sets. */
  makeScope = newScope: f:
    let self = f self // {
          newScope = scope: newScope (self // scope);
          callPackage = self.newScope {};
          overrideScope = g:
            makeScope newScope
            (self_: let super = f self_; in super // g super self_);
          packages = f;
        };
    in self;

}
