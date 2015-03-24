let
  lib = import ./default.nix;
  inherit (builtins) attrNames isFunction;
in

rec {


  /* `overrideDerivation drv f' takes a derivation (i.e., the result
     of a call to the builtin function `derivation') and returns a new
     derivation in which the attributes of the original are overriden
     according to the function `f'.  The function `f' is called with
     the original derivation attributes.

     `overrideDerivation' allows certain "ad-hoc" customisation
     scenarios (e.g. in ~/.nixpkgs/config.nix).  For instance, if you
     want to "patch" the derivation returned by a package function in
     Nixpkgs to build another version than what the function itself
     provides, you can do something like this:

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


  # usage: (you can use override multiple times)
  # let d = makeOverridable stdenv.mkDerivation { name = ..; buildInputs; }
  #     noBuildInputs = d.override { buildInputs = []; }
  #     additionalBuildInputs = d.override ( args : args // { buildInputs = args.buildInputs ++ [ additional ]; } )
  makeOverridable = f: origArgs:
    let
      ff = f origArgs;
      overrideWith = newArgs: origArgs // (if builtins.isFunction newArgs then newArgs origArgs else newArgs);
    in
      if builtins.isAttrs ff then (ff //
        { override = newArgs: makeOverridable f (overrideWith newArgs);
          deepOverride = newArgs:
            makeOverridable f (lib.overrideExisting (lib.mapAttrs (deepOverrider newArgs) origArgs) newArgs);
          overrideDerivation = fdrv:
            makeOverridable (args: overrideDerivation (f args) fdrv) origArgs;
        })
      else if builtins.isFunction ff then
        { override = newArgs: makeOverridable f (overrideWith newArgs);
          __functor = self: ff;
          deepOverride = throw "deepOverride not yet supported for functors";
          overrideDerivation = throw "overrideDerivation not yet supported for functors";
        }
      else ff;

  deepOverrider = newArgs: name: x: if builtins.isAttrs x then (
    if x ? deepOverride then (x.deepOverride newArgs) else
    if x ? override then (x.override newArgs) else
    x) else x;


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
      f    = if builtins.isFunction fn then fn else import fn;
      auto = builtins.intersectAttrs (builtins.functionArgs f) autoArgs;
    in makeOverridable f (auto // args);


  /* Add attributes to each output of a derivation without changing the derivation itself */
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
  in commonAttrs.${drv.outputName};


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

}
