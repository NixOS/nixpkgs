/* Some functions for manipulating meta attributes, as well as the
   name attribute. */

{ lib }:

rec {


  /* Add to or override the meta attributes of the given
     derivation.

     Example:
       addMetaAttrs {description = "Bla blah";} somePkg
  */
  addMetaAttrs = newAttrs: drv:
    drv // { meta = (drv.meta or {}) // newAttrs; };


  /* Disable Hydra builds of given derivation.
  */
  dontDistribute = drv: addMetaAttrs { hydraPlatforms = []; } drv;


  /* Change the symbolic name of a package for presentation purposes
     (i.e., so that nix-env users can tell them apart).
  */
  setName = name: drv: drv // {inherit name;};


  /* Like `setName', but takes the previous name as an argument.

     Example:
       updateName (oldName: oldName + "-experimental") somePkg
  */
  updateName = updater: drv: drv // {name = updater (drv.name);};


  /* Append a suffix to the name of a package (before the version
     part). */
  appendToName = suffix: updateName (name:
    let x = builtins.parseDrvName name; in "${x.name}-${suffix}-${x.version}");


  /* Apply a function to each derivation and only to derivations in an attrset
  */
  mapDerivationAttrset = f: set: lib.mapAttrs (name: pkg: if lib.isDerivation pkg then (f pkg) else pkg) set;


  /* Decrease the nix-env priority of the package, i.e., other
     versions/variants of the package will be preferred.
  */
  lowPrio = drv: addMetaAttrs { priority = 10; } drv;


  /* Apply lowPrio to an attrset with derivations
  */
  lowPrioSet = set: mapDerivationAttrset lowPrio set;


  /* Increase the nix-env priority of the package, i.e., this
     version/variant of the package will be preferred.
  */
  hiPrio = drv: addMetaAttrs { priority = -10; } drv;


  /* Apply hiPrio to an attrset with derivations
  */
  hiPrioSet = set: mapDerivationAttrset hiPrio set;


  /* Check to see if a platform is matched by the given `meta.platforms`
     element.

     A `meta.platform` pattern is either

       1. (legacy) a system string.

       2. (modern) a pattern for the platform `parsed` field.

     We can inject these into a patten for the whole of a structured platform,
     and then match that.
  */
  platformMatch = platform: elem: let
      pattern =
        if builtins.isString elem
        then { system = elem; }
        else { parsed = elem; };
    in lib.matchAttrs pattern platform;

  enableIfAvailable = p: if p.meta.available or true then [ p ] else [];
}
