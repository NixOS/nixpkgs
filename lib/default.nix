/* Library of low-level helper functions for nix expressions.
 *
 * Please implement (mostly) exhaustive unit tests
 * for new functions in `./tests.nix'.
 */
let

  inherit (import ./fixed-points.nix {}) makeExtensible;

  lib = makeExtensible (self: let
    callLibs = file: import file { lib = self; };
  in with self; {

    # often used, or depending on very little
    trivial = callLibs ./trivial.nix;
    fixedPoints = callLibs ./fixed-points.nix;

    # datatypes
    attrsets = callLibs ./attrsets.nix;
    lists = callLibs ./lists.nix;
    strings = callLibs ./strings.nix;
    stringsWithDeps = callLibs ./strings-with-deps.nix;

    # packaging
    customisation = callLibs ./customisation.nix;
    maintainers = import ../maintainers/maintainer-list.nix;
    teams = callLibs ../maintainers/team-list.nix;
    meta = callLibs ./meta.nix;
    sources = callLibs ./sources.nix;
    versions = callLibs ./versions.nix;

    # module system
    modules = callLibs ./modules.nix;
    options = callLibs ./options.nix;
    types = callLibs ./types.nix;

    # constants
    licenses = callLibs ./licenses.nix;
    systems = callLibs ./systems;

    # serialization
    cli = callLibs ./cli.nix;
    generators = callLibs ./generators.nix;

    # misc
    asserts = callLibs ./asserts.nix;
    debug = callLibs ./debug.nix;
    misc = callLibs ./deprecated.nix;

    # domain-specific
    fetchers = callLibs ./fetchers.nix;

    # Eval-time filesystem handling
    filesystem = callLibs ./filesystem.nix;

    # back-compat aliases
    platforms = systems.doubles;

    # linux kernel configuration
    kernel = callLibs ./kernel.nix;

    inherit (builtins) add addErrorContext attrNames concatLists
      deepSeq elem elemAt filter genericClosure genList getAttr
      hasAttr head isAttrs isBool isInt isList isString length
      lessThan listToAttrs pathExists readFile replaceStrings seq
      stringLength sub substring tail;
    inherit (trivial) id const pipe concat or and bitAnd bitOr bitXor
      bitNot boolToString mergeAttrs flip mapNullable inNixShell min max
      importJSON warn info showWarnings nixpkgsVersion version mod compare
      splitByAndCompare functionArgs setFunctionArgs isFunction;
    inherit (fixedPoints) fix fix' converge extends composeExtensions
      makeExtensible makeExtensibleWithCustomName;
    inherit (attrsets) attrByPath hasAttrByPath setAttrByPath
      getAttrFromPath attrVals attrValues getAttrs catAttrs filterAttrs
      filterAttrsRecursive foldAttrs collect nameValuePair mapAttrs
      mapAttrs' mapAttrsToList mapAttrsRecursive mapAttrsRecursiveCond
      genAttrs isDerivation toDerivation optionalAttrs
      zipAttrsWithNames zipAttrsWith zipAttrs recursiveUpdateUntil
      recursiveUpdate matchAttrs overrideExisting getOutput getBin
      getLib getDev getMan chooseDevOutputs zipWithNames zip
      recurseIntoAttrs dontRecurseIntoAttrs;
    inherit (lists) singleton forEach foldr fold foldl foldl' imap0 imap1
      concatMap flatten remove findSingle findFirst any all count
      optional optionals toList range partition zipListsWith zipLists
      reverseList listDfs toposort sort naturalSort compareLists take
      drop sublist last init crossLists unique intersectLists
      subtractLists mutuallyExclusive groupBy groupBy';
    inherit (strings) concatStrings concatMapStrings concatImapStrings
      intersperse concatStringsSep concatMapStringsSep
      concatImapStringsSep makeSearchPath makeSearchPathOutput
      makeLibraryPath makeBinPath optionalString
      hasInfix hasPrefix hasSuffix stringToCharacters stringAsChars escape
      escapeShellArg escapeShellArgs replaceChars lowerChars
      upperChars toLower toUpper addContextFrom splitString
      removePrefix removeSuffix versionOlder versionAtLeast
      getName getVersion
      nameFromURL enableFeature enableFeatureAs withFeature
      withFeatureAs fixedWidthString fixedWidthNumber isStorePath
      toInt readPathsFromFile fileContents;
    inherit (stringsWithDeps) textClosureList textClosureMap
      noDepEntry fullDepEntry packEntry stringAfter;
    inherit (customisation) overrideDerivation makeOverridable
      callPackageWith callPackagesWith extendDerivation hydraJob
      makeScope;
    inherit (meta) addMetaAttrs dontDistribute setName updateName
      appendToName mapDerivationAttrset setPrio lowPrio lowPrioSet hiPrio
      hiPrioSet;
    inherit (sources) pathType pathIsDirectory cleanSourceFilter
      cleanSource sourceByRegex sourceFilesBySuffices
      commitIdFromGitRepo cleanSourceWith pathHasContext
      canCleanSource pathIsRegularFile pathIsGitRepo;
    inherit (modules) evalModules unifyModuleSyntax
      applyIfFunction mergeModules
      mergeModules' mergeOptionDecls evalOptionValue mergeDefinitions
      pushDownProperties dischargeProperties filterOverrides
      sortProperties fixupOptionType mkIf mkAssert mkMerge mkOverride
      mkOptionDefault mkDefault mkForce mkVMOverride mkStrict
      mkFixStrictness mkOrder mkBefore mkAfter mkAliasDefinitions
      mkAliasAndWrapDefinitions fixMergeModules mkRemovedOptionModule
      mkRenamedOptionModule mkMergedOptionModule mkChangedOptionModule
      mkAliasOptionModule doRename;
    inherit (options) isOption mkEnableOption mkSinkUndeclaredOptions
      mergeDefaultOption mergeOneOption mergeEqualOption getValues
      getFiles optionAttrSetToDocList optionAttrSetToDocList'
      scrubOptionValue literalExample showOption showFiles
      unknownModule mkOption;
    inherit (types) isType setType defaultTypeMerge defaultFunctor
      isOptionType mkOptionType;
    inherit (asserts)
      assertMsg assertOneOf;
    inherit (debug) addErrorContextToAttrs traceIf traceVal traceValFn
      traceXMLVal traceXMLValMarked traceSeq traceSeqN traceValSeq
      traceValSeqFn traceValSeqN traceValSeqNFn traceShowVal
      traceShowValMarked showVal traceCall traceCall2 traceCall3
      traceValIfNot runTests testAllTrue traceCallXml attrNamesToStr;
    inherit (misc) maybeEnv defaultMergeArg defaultMerge foldArgs
      maybeAttrNullable maybeAttr ifEnable checkFlag getValue
      checkReqs uniqList uniqListExt condConcat lazyGenericClosure
      innerModifySumArgs modifySumArgs innerClosePropagation
      closePropagation mapAttrsFlatten nvs setAttr setAttrMerge
      mergeAttrsWithFunc mergeAttrsConcatenateValues
      mergeAttrsNoOverride mergeAttrByFunc mergeAttrsByFuncDefaults
      mergeAttrsByFuncDefaultsClean mergeAttrBy
      fakeHash fakeSha256 fakeSha512
      nixType imap;
    inherit (versions)
      splitVersion;
  });
in lib
