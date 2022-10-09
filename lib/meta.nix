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


  /* Apply a function to each derivation and only to derivations in an attrset.
  */
  mapDerivationAttrset = f: set: lib.mapAttrs (name: pkg: if lib.isDerivation pkg then (f pkg) else pkg) set;

  /* Set the nix-env priority of the package.
  */
  setPrio = priority: addMetaAttrs { inherit priority; };

  /* Decrease the nix-env priority of the package, i.e., other
     versions/variants of the package will be preferred.
  */
  lowPrio = setPrio 10;

  /* Apply lowPrio to an attrset with derivations
  */
  lowPrioSet = set: mapDerivationAttrset lowPrio set;


  /* Increase the nix-env priority of the package, i.e., this
     version/variant of the package will be preferred.
  */
  hiPrio = setPrio (-10);

  /* Apply hiPrio to an attrset with derivations
  */
  hiPrioSet = set: mapDerivationAttrset hiPrio set;


  /* Check to see if a platform is matched by the given `meta.platforms`
     element.

     A `meta.platform` pattern is either

       1. (legacy) a system string.

       2. (modern) a pattern for the platform `parsed` field.

     We can inject these into a pattern for the whole of a structured platform,
     and then match that.
  */
  platformMatch = platform: elem: let
      pattern =
        if builtins.isString elem
        then { system = elem; }
        else { parsed = elem; };
    in lib.matchAttrs pattern platform;

  /* Check if a package is available on a given platform.

     A package is available on a platform if both

       1. One of `meta.platforms` pattern matches the given
          platform, or `meta.platforms` is not present.

       2. None of `meta.badPlatforms` pattern matches the given platform.
  */
  availableOn = platform: pkg:
    ((!pkg?meta.platforms) || lib.any (platformMatch platform) pkg.meta.platforms) &&
    lib.all (elem: !platformMatch platform elem) (pkg.meta.badPlatforms or []);

  /* Get the corresponding attribute in lib.licenses
     from the SPDX ID.
     For SPDX IDs, see
     https://spdx.org/licenses

     Type:
       getLicenseFromSpdxId :: str -> AttrSet

     Example:
       lib.getLicenseFromSpdxId "MIT" == lib.licenses.mit
       => true
       lib.getLicenseFromSpdxId "mIt" == lib.licenses.mit
       => true
       lib.getLicenseFromSpdxId "MY LICENSE"
       => trace: warning: getLicenseFromSpdxId: No license matches the given SPDX ID: MY LICENSE
       => { shortName = "MY LICENSE"; }
  */
  getLicenseFromSpdxId =
    let
      spdxLicenses = lib.mapAttrs (id: ls: assert lib.length ls == 1; builtins.head ls)
        (lib.groupBy (l: lib.toLower l.spdxId) (lib.filter (l: l ? spdxId) (lib.attrValues lib.licenses)));
    in licstr:
      spdxLicenses.${ lib.toLower licstr } or (
        lib.warn "getLicenseFromSpdxId: No license matches the given SPDX ID: ${licstr}"
        { shortName = licstr; }
      );

  /* Get the path to the main program of a derivation with either
     meta.mainProgram or pname or name

     Type: getExe :: derivation -> string

     Example:
       getExe pkgs.hello
       => "/nix/store/g124820p9hlv4lj8qplzxw1c44dxaw1k-hello-2.12/bin/hello"
       getExe pkgs.mustache-go
       => "/nix/store/am9ml4f4ywvivxnkiaqwr0hyxka1xjsf-mustache-go-1.3.0/bin/mustache"
  */
  getExe = x:
    "${lib.getBin x}/bin/${x.meta.mainProgram or (lib.getName x)}";
}
