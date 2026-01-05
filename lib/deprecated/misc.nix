{ lib }:

let
  inherit (lib)
    and
    any
    attrByPath
    attrNames
    compare
    concat
    concatMap
    elem
    filter
    foldl
    foldr
    genericClosure
    head
    imap1
    init
    isAttrs
    isFunction
    isInt
    isList
    lists
    listToAttrs
    mapAttrs
    mergeAttrs
    meta
    nameValuePair
    tail
    toList
    ;

  # returns default if env var is not set
  maybeEnv =
    name: default:
    let
      value = builtins.getEnv name;
    in
    if value == "" then default else value;

  defaultMergeArg = x: y: if builtins.isAttrs y then y else (y x);
  defaultMerge = x: y: x // (defaultMergeArg x y);
  foldArgs =
    merger: f: init: x:
    let
      arg = (merger init (defaultMergeArg init x));
      # now add the function with composed args already applied to the final attrs
      base = (
        setAttrMerge "passthru" { } (f arg) (
          z:
          z
          // {
            function = foldArgs merger f arg;
            args = (attrByPath [ "passthru" "args" ] { } z) // x;
          }
        )
      );
      withStdOverrides = base // {
        override = base.passthru.function;
      };
    in
    withStdOverrides;

  # shortcut for attrByPath ["name"] default attrs
  maybeAttrNullable = maybeAttr;

  # shortcut for attrByPath ["name"] default attrs
  maybeAttr =
    name: default: attrs:
    attrs.${name} or default;

  # Returns the second argument if the first one is true or the empty version
  # of the second argument.
  ifEnable =
    cond: val:
    if cond then
      val
    else if builtins.isList val then
      [ ]
    else if builtins.isAttrs val then
      { }
    # else if builtins.isString val then ""
    else if val == true || val == false then
      false
    else
      null;

  # Returns true only if there is an attribute and it is true.
  checkFlag =
    attrSet: name:
    if name == "true" then
      true
    else if name == "false" then
      false
    else if (elem name (attrByPath [ "flags" ] [ ] attrSet)) then
      true
    else
      attrByPath [ name ] false attrSet;

  # Input : attrSet, [ [name default] ... ], name
  # Output : its value or default.
  getValue =
    attrSet: argList: name:
    (attrByPath [ name ] (
      if checkFlag attrSet name then
        true
      else if argList == [ ] then
        null
      else
        let
          x = builtins.head argList;
        in
        if (head x) == name then (head (tail x)) else (getValue attrSet (tail argList) name)
    ) attrSet);

  # Input : attrSet, [[name default] ...], [ [flagname reqs..] ... ]
  # Output : are reqs satisfied? It's asserted.
  checkReqs =
    attrSet: argList: condList:
    (foldr and true (
      map (
        x:
        let
          name = (head x);
        in

        (
          (checkFlag attrSet name)
          -> (foldr and true (
            map (
              y:
              let
                val = (getValue attrSet argList y);
              in
              (val != null) && (val != false)
            ) (tail x)
          ))
        )
      ) condList
    ));

  # This function has O(n^2) performance.
  uniqList =
    {
      inputList,
      acc ? [ ],
    }:
    let
      go =
        xs: acc:
        if xs == [ ] then
          [ ]
        else
          let
            x = head xs;
            y = if elem x acc then [ ] else [ x ];
          in
          y ++ go (tail xs) (y ++ acc);
    in
    go inputList acc;

  uniqListExt =
    {
      inputList,
      outputList ? [ ],
      getter ? (x: x),
      compare ? (x: y: x == y),
    }:
    if inputList == [ ] then
      outputList
    else
      let
        x = head inputList;
        isX = y: (compare (getter y) (getter x));
        newOutputList = outputList ++ (if any isX outputList then [ ] else [ x ]);
      in
      uniqListExt {
        outputList = newOutputList;
        inputList = (tail inputList);
        inherit getter compare;
      };

  condConcat =
    name: list: checker:
    if list == [ ] then
      name
    else if checker (head list) then
      condConcat (name + (head (tail list))) (tail (tail list)) checker
    else
      condConcat name (tail (tail list)) checker;

  lazyGenericClosure =
    { startSet, operator }:
    let
      work =
        list: doneKeys: result:
        if list == [ ] then
          result
        else
          let
            x = head list;
            key = x.key;
          in
          if elem key doneKeys then
            work (tail list) doneKeys result
          else
            work (tail list ++ operator x) ([ key ] ++ doneKeys) ([ x ] ++ result);
    in
    work startSet [ ] [ ];

  innerModifySumArgs =
    f: x: a: b:
    if b == null then (f a b) // x else innerModifySumArgs f x (a // b);
  modifySumArgs = f: x: innerModifySumArgs f x { };

  innerClosePropagation =
    acc: xs:
    if xs == [ ] then
      acc
    else
      let
        y = head xs;
        ys = tail xs;
      in
      if !isAttrs y then
        innerClosePropagation acc ys
      else
        let
          acc' = [ y ] ++ acc;
        in
        innerClosePropagation acc' (uniqList {
          inputList =
            (maybeAttrNullable "propagatedBuildInputs" [ ] y)
            ++ (maybeAttrNullable "propagatedNativeBuildInputs" [ ] y)
            ++ ys;
          acc = acc';
        });

  closePropagationSlow = list: (uniqList { inputList = (innerClosePropagation [ ] list); });

  # This is an optimisation of closePropagation which avoids the O(n^2) behavior
  # Using a list of derivations, it generates the full closure of the propagatedXXXBuildInputs
  # The ordering / sorting / comparison is done based on the `outPath`
  # attribute of each derivation.
  # On some benchmarks, it performs up to 15 times faster than closePropagation.
  # See https://github.com/NixOS/nixpkgs/pull/194391 for details.
  closePropagationFast =
    list:
    map (x: x.val) (
      builtins.genericClosure {
        startSet = map (x: {
          key = x.outPath;
          val = x;
        }) (builtins.filter (x: x != null) list);
        operator =
          item:
          if !builtins.isAttrs item.val then
            [ ]
          else
            builtins.concatMap (
              x:
              if x != null then
                [
                  {
                    key = x.outPath;
                    val = x;
                  }
                ]
              else
                [ ]
            ) ((item.val.propagatedBuildInputs or [ ]) ++ (item.val.propagatedNativeBuildInputs or [ ]));
      }
    );

  closePropagation = if builtins ? genericClosure then closePropagationFast else closePropagationSlow;

  # attribute set containing one attribute
  nvs = name: value: listToAttrs [ (nameValuePair name value) ];
  # adds / replaces an attribute of an attribute set
  setAttr =
    set: name: v:
    set // (nvs name v);

  # setAttrMerge (similar to mergeAttrsWithFunc but only merges the values of a particular name)
  # setAttrMerge "a" [] { a = [2];} (x: x ++ [3]) -> { a = [2 3]; }
  # setAttrMerge "a" [] {         } (x: x ++ [3]) -> { a = [  3]; }
  setAttrMerge =
    name: default: attrs: f:
    setAttr attrs name (f (maybeAttr name default attrs));

  # Using f = a: b = b the result is similar to //
  # merge attributes with custom function handling the case that the attribute
  # exists in both sets
  mergeAttrsWithFunc =
    f: set1: set2:
    foldr (n: set: if set ? ${n} then setAttr set n (f set.${n} set2.${n}) else set) (set2 // set1) (
      attrNames set2
    );

  # merging two attribute set concatenating the values of same attribute names
  # eg { a = 7; } {  a = [ 2 3 ]; } becomes { a = [ 7 2 3 ]; }
  mergeAttrsConcatenateValues = mergeAttrsWithFunc (a: b: (toList a) ++ (toList b));

  # merges attributes using //, if a name exists in both attributes
  # an error will be triggered unless its listed in mergeLists
  # so you can mergeAttrsNoOverride { buildInputs = [a]; } { buildInputs = [a]; } {} to get
  # { buildInputs = [a b]; }
  # merging buildPhase doesn't really make sense. The cases will be rare where appending /prefixing will fit your needs?
  # in these cases the first buildPhase will override the second one
  # ! deprecated, use mergeAttrByFunc instead
  mergeAttrsNoOverride =
    {
      mergeLists ? [
        "buildInputs"
        "propagatedBuildInputs"
      ],
      overrideSnd ? [ "buildPhase" ],
    }:
    attrs1: attrs2:
    foldr (
      n: set:
      setAttr set n (
        if set ? ${n} then # merge
          if
            elem n mergeLists # attribute contains list, merge them by concatenating
          then
            attrs2.${n} ++ attrs1.${n}
          else if elem n overrideSnd then
            attrs1.${n}
          else
            throw "error mergeAttrsNoOverride, attribute ${n} given in both attributes - no merge func defined"
        else
          attrs2.${n} # add attribute not existing in attr1
      )
    ) attrs1 (attrNames attrs2);

  # example usage:
  # mergeAttrByFunc  {
  #   inherit mergeAttrBy; # defined below
  #   buildInputs = [ a b ];
  # } {
  #  buildInputs = [ c d ];
  # };
  # will result in
  # { mergeAttrsBy = [...]; buildInputs = [ a b c d ]; }
  # is used by defaultOverridableDelayableArgs and can be used when composing using
  # foldArgs, composedArgsAndFun or applyAndFun. Example: composableDerivation in all-packages.nix
  mergeAttrByFunc =
    x: y:
    let
      mergeAttrBy2 = {
        mergeAttrBy = mergeAttrs;
      }
      // (maybeAttr "mergeAttrBy" { } x)
      // (maybeAttr "mergeAttrBy" { } y);
    in
    foldr mergeAttrs { } [
      x
      y
      (mapAttrs
        (
          a: v: # merge special names using given functions
          if x ? ${a} then
            if y ? ${a} then
              v x.${a} y.${a} # both have attr, use merge func
            else
              x.${a} # only x has attr
          else
            y.${a} # only y has attr)
        )
        (
          removeAttrs mergeAttrBy2
            # don't merge attrs which are neither in x nor y
            (filter (a: !x ? ${a} && !y ? ${a}) (attrNames mergeAttrBy2))
        )
      )
    ];
  mergeAttrsByFuncDefaults = foldl mergeAttrByFunc { inherit mergeAttrBy; };
  mergeAttrsByFuncDefaultsClean = list: removeAttrs (mergeAttrsByFuncDefaults list) [ "mergeAttrBy" ];

  # sane defaults (same name as attr name so that inherit can be used)
  mergeAttrBy = # { buildInputs = concatList; [...]; passthru = mergeAttr; [..]; }
    listToAttrs (
      map (n: nameValuePair n concat) [
        "nativeBuildInputs"
        "buildInputs"
        "propagatedBuildInputs"
        "configureFlags"
        "prePhases"
        "postAll"
        "patches"
      ]
    )
    // listToAttrs (
      map (n: nameValuePair n mergeAttrs) [
        "passthru"
        "meta"
        "cfg"
        "flags"
      ]
    )
    // listToAttrs (
      map (n: nameValuePair n (a: b: "${a}\n${b}")) [
        "preConfigure"
        "postInstall"
      ]
    );

  nixType =
    x:
    if isAttrs x then
      if x ? outPath then "derivation" else "attrs"
    else if isFunction x then
      "function"
    else if isList x then
      "list"
    else if x == true then
      "bool"
    else if x == false then
      "bool"
    else if x == null then
      "null"
    else if isInt x then
      "int"
    else
      "string";

  /**
    # Deprecated

    For historical reasons, imap has an index starting at 1.

    But for consistency with the rest of the library we want an index
    starting at zero.
  */
  imap = imap1;

  # Fake hashes. Can be used as hash placeholders, when computing hash ahead isn't trivial
  fakeHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  fakeSha256 = "0000000000000000000000000000000000000000000000000000000000000000";
  fakeSha512 = "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

in

# Everything in this attrset is the public interface of the file.
{
  inherit
    checkFlag
    checkReqs
    closePropagation
    closePropagationFast
    closePropagationSlow
    condConcat
    defaultMerge
    defaultMergeArg
    fakeHash
    fakeSha256
    fakeSha512
    foldArgs
    getValue
    ifEnable
    imap
    innerClosePropagation
    innerModifySumArgs
    lazyGenericClosure
    maybeAttr
    maybeAttrNullable
    maybeEnv
    mergeAttrBy
    mergeAttrByFunc
    mergeAttrsByFuncDefaults
    mergeAttrsByFuncDefaultsClean
    mergeAttrsConcatenateValues
    mergeAttrsNoOverride
    mergeAttrsWithFunc
    modifySumArgs
    nixType
    nvs
    setAttr
    setAttrMerge
    uniqList
    uniqListExt
    ;
}
