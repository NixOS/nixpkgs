{ lib }:

let

  /* Escape a string begins with a number, a hyphen or an underscore
    by adding a leading underscore
    to be used as an attribute name.

    Type:
    escapeAttrPrefix :: string -> string

    Example:
    escapeAttrPrefix "4ops"
    => "_4ops"
    escapeAttrPrefix "bbenoist"
    => "bbenoist"
  */
  escapeAttrPrefix = attrname:
    if (builtins.match "[0-9_\\-].*" attrname != null) then
      "_" + attrname
    else
      attrname;

  /* Unescape an attribute name
    escaped with `escapeAttrPrefix`.

    Type:
    unescapeAttrPrefix :: string -> string

    Example:
    unescapeAttrPrefix "_4ops"
    => "4ops"
    unescapeAttrPrefix "bbenoist"
    => "bbenoist"
  */
  unescapeAttrPrefix = attrname:
    if (builtins.match "_.*" attrname != null) then
      builtins.substring 1 ((builtins.stringLength attrname) - 1) attrname
    else
      attrname;

  /* Map an extension attribute set
    (an attribute set with structure
    `{ bbenoist = { Nix = foo; ... }; ... }`)
    to another attribute set of the same structure.
    The attribute set for extension derivations (`myregistry.extension`)
    may be polluted by `lib.recurseIntoAttrs`
    and should not be mapped against directly.
    In this case, use mapRegistryRefAttrs or iterateRegistryRefAttrs instead.

    Type:
    mapRegistryRefAttrs :: ( str -> str -> Any -> Any ) -> AttrSet -> AttrSet

    Example:
    mapRegistryRefAttrs mapFunction { bbenoist = { Nix = foo; }; }
    => { bbenoist = { Nix = mapFunction "bbenoist" "Nix" foo; } } }
  */
  mapExtensionAttrs = (mapFunction:
    lib.mapAttrs (publisher_:
      lib.mapAttrs (name_:
        mapFunction (unescapeAttrPrefix publisher_) (unescapeAttrPrefix name_)
      )
    )
  );

  /* Map the registry reference attribute set
    (an attribute set with structure
    `{ bbenoist = { Nix = { publisher = "bbenoist" ; name = "Nix"; ... }; ... }; ... }`)
    to another attribute set of the same structure

    Type:
    mapRegistryRefAttrs :: ( { publisher :: string, name :: string, ... } -> Any ) -> AttrSet -> AttrSet

    Example:
    mapRegistryRefAttrs mapFunction { bbenoist = { Nix = { publisher = "bbenoist"; "name" = "Nix"; }; }; }
    => { bbenoist = { Nix = mapFunction { publisher = "bbenoist"; name = "Nix"; } } }
    mapRegistryRefAttrs mapFunction { bbenoist = { Nix = foo; }; }
    => { bbenoist = { Nix = mapFunction foo; } }
  */
  mapRegistryRefAttrs = (mapFunction:
    lib.mapAttrs (publisher_:
      lib.mapAttrs (name_:
        mapFunction
      )
    )
  );

  /* Iterate over the registry reference attribute set
    Operations to `myregistry.extensions`
    should reference `myregistry.registry-reference-attrs`,
    since the former may be polluted by `lib.recurseIntoAttrs`.

    Type:
    iterateRegistryRefAttrs :: ( { publisher :: string, name :: string, ... } -> a -> a ) -> AttrSet -> a

    Example:
    iterateRegistryRefAttrs iterFunction { bbenoist = { Doxygen = { publisher = "bbenoist"; name = "Doxygen"; }; Nix = { publisher = "bbenoist"; name = "Nix"; }; }; } foo
    => iterFunction { publisher = "bbenoist"; name = "Nix"; } (iterFunction { publisher = "bbenoist"; name = "Doxygen"; } foo)
  */
  iterateRegistryRefAttrs = iterFunction: registry-reference-attrs: extension-attrs:
    builtins.foldl'
      (prev-prev-attrs: publisher_:
        builtins.foldl'
          (prev-attrs: name_:
            iterFunction registry-reference-attrs.${publisher_}.${name_} prev-attrs
          )
          prev-prev-attrs
          (builtins.attrNames registry-reference-attrs.${publisher_})
      )
      extension-attrs
      (builtins.attrNames registry-reference-attrs);


  /* Add an object myobject into an attribute set attrset
    as `attrset.mypublisher.myname.myobject`

    Type:
    addExtensionIntoAttrs :: ( a -> a -> a ) AttrSet  -> string -> string-> a -> AttrSet

    Example:
    addExtensionIntoAttrs (a: b: b) { bbenoist = { Nix = foo; }; } "bbenoist" "Doxygen" bar
    => { bbenoist = { Doxygen = bar; Nix = foo; }; }
  */
  addExtensionIntoAttrs =
    (mergeFunction: extension-attrs: publisher: name: extension:
      let
        publisher_ = escapeAttrPrefix publisher;
        name_ = escapeAttrPrefix name;
      in
      extension-attrs // {
        "${publisher_}" =
          if builtins.hasAttr publisher_ extension-attrs then
            extension-attrs.${publisher_} // {
              "${name_}" =
                if builtins.hasAttr name_ extension-attrs.${publisher_} then
                  mergeFunction extension-attrs.${publisher_}.${name_} extension
                else
                  extension;
            }
          else {
            "${name_}" = extension;
          };
      });

  /* Add a registry reference into the registry reference attrset
    as `registry-reference-attrs."${escapeAttrPrefix publisher}"."${escapeAttrPrefix name}"`

    Type:
    addExtensionIntoAttrs :: AttrSet -> { publisher :: string, name :: string, ... } -> AttrSet

    Example:
    addRegistryRefIntoAttrs { bbenoist = { Nix = { publisher = "bbenoist"; name = "Nix"; }; }; } { publisher = "bbenoist"; name = "Doxygen"; }
    => { bbenoist = { Doxygen = { publisher = "bbenoist"; name = "Doxygen"; }; Nix = { publisher = "bbenoist"; name = "Nix"; }; }; }
  */
  addRegistryRefIntoAttrs = registry-reference-attrs: registry-reference:
    (addExtensionIntoAttrs (a: b: b)
      registry-reference-attrs
      registry-reference.publisher
      registry-reference.name
      registry-reference);

  /* Loop through a list of registry reference and
    add all the elements into the given registry reference attrset.

    Type:
    foldRegistryRefList :: AttrSet -> [ { publisher :: string, name :: string, ... } ] -> AttrSet

    Example:
    foldRegistryRefList { bbenoist = { Nix = { publisher = "bbenoist"; name = "Nix"; }; }; } [ { publisher = "bbenoist"; name = "Doxygen"; } ]
    => { bbenoist = { Doxygen = { publisher = "bbenoist"; name = "Doxygen"; }; Nix = { publisher = "bbenoist"; name = "Nix"; }; }; }
  */
  foldRegistryRefList = registry-reference-attrs: registry-reference-list:
    builtins.foldl' addRegistryRefIntoAttrs registry-reference-attrs
      registry-reference-list;

  /*
    Convert a list of registry references to the corresponding attribute set.

    Type:
    registryRefListToAttrs :: [ { publisher :: string, name :: string, ... } ] -> AttrSet

    Example:
    registryRefListToAttrs [ { publisher = "bbenoist"; name = "Doxygen"; }, { publisher = "bbenoist"; name = "Nix"; } ]
    => { bbenoist = { Doxygen = { publisher = "bbenoist"; name = "Doxygen"; }; Nix = { publisher = "bbenoist"; name = "Nix"; }; }; }
  */
  registryRefListToAttrs = registry-reference-list:
    foldRegistryRefList { } registry-reference-list;

  /*
    Merge two extension attributes with a merge function.

    Type: mergeExtensionAttrsWith :: ( Any -> Any -> Any ) -> AttrSet -> AttrSet

    Example:
    mergeExtensionAttrsWith (a: b: b) { bbenoist = { Doxygen = alpha; Nix = beta; }; } { bbenoist = { Nix = gamma; vagrant = delta; }; }
    => { bbenoist = { Doxygen = alpha; Nix = gamma; vagrant = delta; }; }
  */
  mergeExtensionAttrsWith = (mergeFunction: extension-attrs1: extension-attrs2:
    builtins.foldl'
      (extension-attrs: publisher_:
        extension-attrs // {
          "${publisher_}" =
            if
              (builtins.hasAttr publisher_ extension-attrs)
              && (builtins.isAttrs extension-attrs.${publisher_})
            then
              builtins.foldl'
                (name_: extension-subattrs:
                  extension-subattrs // {
                    "${name_}" =
                      if builtins.hasAttr name_ extension-subattrs then
                        mergeFunction extension-subattrs.${name_}
                          extension-attrs2.${publisher_}.${name_}
                      else
                        extension-attrs2.${publisher_}.${name_};
                  })
                extension-attrs.${publisher_}
                (builtins.attrNames extension-attrs2.${publisher_})
            else
              extension-attrs2.${publisher_};
        })
      extension-attrs1
      (builtins.attrNames extension-attrs2));

  /* Apply `recurseIntoAttrs` to
     every publishers and their extension attributes
     in an extension attribute set.

     Type:
     recurseIntoExtensionSubattrs :: AttrSet -> AttrSet

     Example:
     myregistry.override = { overlays = [
       (final: prev: {
         extensions = recurseIntoExtensionSubattrs prev.extensions;
       })
     ]
  */
  recurseIntoExtensionSubattrs = lib.mapAttrs (publisher: subattrs:
    if builtins.isAttrs subattrs
    then lib.recurseIntoAttrs subattrs else subattrs
  );

  /* Apply `recurseIntoAttrs`
     to an extension attribute set.

     Type:
     recurseIntoExtensionAttrs :: AttrSet -> AttrSet

     Example:
     myregistry.override = { overlays = [
       (final: prev: {
         extensions = recurseIntoExtensionAttrs prev.extensions;
       })
     ]
  */
  recurseIntoExtensionAttrs = extension-attrs:
    lib.recurseIntoAttrs (recurseIntoExtensionSubattrs extension-attrs);

  /* Apply `dontRecurseIntoAttrs` to
     every publishers and their extension attributes
     in an extension attribute set.

     Type:
     dontRecurseIntoExtensionSubattrs :: AttrSet -> AttrSet

     Example:
     myregistry.override = { overlays = [
       (final: prev: {
         extensions = dontRecurseIntoExtensionSubattrs prev.extensions;
       })
     ]
  */
  dontRecurseIntoExtensionSubattrs = lib.mapAttrs (publisher: subattrs:
    if builtins.isAttrs subattrs
    then lib.dontRecurseIntoAttrs subattrs else subattrs
  );

  /* Apply `dontRecurseIntoAttrs`
     to an extension attribute set.

     Type:
     dontRecurseIntoExtensionAttrs :: AttrSet -> AttrSet

     Example:
     myregistry.override = { overlays = [
       (final: prev: {
         extensions = dontRecurseIntoExtensionAttrs prev.extensions;
       })
     ]
  */
  dontRecurseIntoExtensionAttrs = extension-attrs:
    lib.dontRecurseIntoAttrs (dontRecurseIntoExtensionSubattrs extension-attrs);

  /* Return a sorted lists containing elements in both lists with duplication removed.

     Type:
     uniquelyUnionLists :: [ a ] -> [ a ] -> [ a ];

     Example:
     uniquelyUnionLists [ 2 4 ] [ 1 3 2 ]
     => [ 1 2 3 4 ]
  */
  uniquelyUnionLists = La: Lb:
    lib.unique (builtins.sort (a: b: a < b) (La ++ Lb));

  /* Like `lib.getAttrs`, but returns only the existing attributes
     when some are missing,
     instead of throwing an error.
     TODO: Make it into `lib/attrsets.nix`
  */
  getExistingAttrs = lib.getExistingAttrs or (attrnames: attrs:
    builtins.foldl'
      (oldAttrs: name:
        if (builtins.hasAttr name attrs) then
          oldAttrs // { "${name}" = attrs.${name}; }
        else
          oldAttrs)
      { }
      attrnames);

in
{
  inherit
    escapeAttrPrefix unescapeAttrPrefix
    mapExtensionAttrs mapRegistryRefAttrs iterateRegistryRefAttrs
    addExtensionIntoAttrs addRegistryRefIntoAttrs foldRegistryRefList
    registryRefListToAttrs mergeExtensionAttrsWith
    recurseIntoExtensionSubattrs recurseIntoExtensionAttrs
    dontRecurseIntoExtensionSubattrs dontRecurseIntoExtensionAttrs
    uniquelyUnionLists
    getExistingAttrs;
}
