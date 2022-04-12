/* Library of low-level helper functions for nix expressions.
 *
 * Please implement (mostly) exhaustive unit tests
 * for new functions in `./tests.nix'.
 */
let

  inherit (import ./fixed-points.nix { inherit lib; }) makeExtensible;

  lib = makeExtensible (self: let
    callLibs = file: import file { lib = self; };
  in {

    # interacting with flakes
    flakes = callLibs ./flakes.nix;

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
    platforms = self.systems.doubles;

    # linux kernel configuration
    kernel = callLibs ./kernel.nix;

    inherit (self.flakes) callLocklessFlake;
    inherit (builtins) add addErrorContext attrNames concatLists
      deepSeq elem elemAt filter genericClosure genList getAttr
      hasAttr head isAttrs isBool isInt isList isString length
      lessThan listToAttrs pathExists readFile replaceStrings seq
      stringLength sub substring tail trace;
    inherit (self.trivial) id const pipe concat or and bitAnd bitOr bitXor
      bitNot boolToString mergeAttrs flip mapNullable inNixShell isFloat min max
      importJSON importTOML warn warnIf warnIfNot throwIf throwIfNot checkListOfEnum
      info showWarnings nixpkgsVersion version isInOldestRelease
      mod compare splitByAndCompare
      functionArgs setFunctionArgs isFunction toFunction
      toHexString toBaseDigits;
    inherit (self.fixedPoints) fix fix' converge extends composeExtensions
      composeManyExtensions makeExtensible makeExtensibleWithCustomName;
    inherit (self.attrsets) attrByPath hasAttrByPath setAttrByPath
      getAttrFromPath attrVals attrValues getAttrs catAttrs filterAttrs
      filterAttrsRecursive foldAttrs collect nameValuePair mapAttrs
      mapAttrs' mapAttrsToList mapAttrsRecursive mapAttrsRecursiveCond
      genAttrs isDerivation toDerivation optionalAttrs
      zipAttrsWithNames zipAttrsWith zipAttrs recursiveUpdateUntil
      recursiveUpdate matchAttrs overrideExisting showAttrPath getOutput getBin
      getLib getDev getMan chooseDevOutputs zipWithNames zip
      recurseIntoAttrs dontRecurseIntoAttrs cartesianProductOfSets
      updateManyAttrsByPath;
    inherit (self.lists) singleton forEach foldr fold foldl foldl' imap0 imap1
      concatMap flatten remove findSingle findFirst any all count
      optional optionals toList range partition zipListsWith zipLists
      reverseList listDfs toposort sort naturalSort compareLists take
      drop sublist last init crossLists unique intersectLists
      subtractLists mutuallyExclusive groupBy groupBy';
    inherit (self.strings) concatStrings concatMapStrings concatImapStrings
      intersperse concatStringsSep concatMapStringsSep
      concatImapStringsSep makeSearchPath makeSearchPathOutput
      makeLibraryPath makeBinPath optionalString
      hasInfix hasPrefix hasSuffix stringToCharacters stringAsChars escape
      escapeShellArg escapeShellArgs escapeRegex escapeXML replaceChars lowerChars
      upperChars toLower toUpper addContextFrom splitString
      removePrefix removeSuffix versionOlder versionAtLeast
      getName getVersion
      nameFromURL enableFeature enableFeatureAs withFeature
      withFeatureAs fixedWidthString fixedWidthNumber isStorePath
      toInt readPathsFromFile fileContents;
    inherit (self.stringsWithDeps) textClosureList textClosureMap
      noDepEntry fullDepEntry packEntry stringAfter;
    inherit (self.customisation) overrideDerivation makeOverridable
      callPackageWith callPackagesWith extendDerivation hydraJob
      makeScope makeScopeWithSplicing;
    inherit (self.meta) addMetaAttrs dontDistribute setName updateName
      appendToName mapDerivationAttrset setPrio lowPrio lowPrioSet hiPrio
      hiPrioSet getLicenseFromSpdxId;
    inherit (self.sources) pathType pathIsDirectory cleanSourceFilter
      cleanSource sourceByRegex sourceFilesBySuffices
      commitIdFromGitRepo cleanSourceWith pathHasContext
      canCleanSource pathIsRegularFile pathIsGitRepo;
    inherit (self.modules) evalModules setDefaultModuleLocation
      unifyModuleSyntax applyModuleArgsIfFunction mergeModules
      mergeModules' mergeOptionDecls evalOptionValue mergeDefinitions
      pushDownProperties dischargeProperties filterOverrides
      sortProperties fixupOptionType mkIf mkAssert mkMerge mkOverride
      mkOptionDefault mkDefault mkImageMediaOverride mkForce mkVMOverride
      mkFixStrictness mkOrder mkBefore mkAfter mkAliasDefinitions
      mkAliasAndWrapDefinitions fixMergeModules mkRemovedOptionModule
      mkRenamedOptionModule mkRenamedOptionModuleWith
      mkMergedOptionModule mkChangedOptionModule
      mkAliasOptionModule mkDerivedConfig doRename;
    inherit (self.options) isOption mkEnableOption mkSinkUndeclaredOptions
      mergeDefaultOption mergeOneOption mergeEqualOption mergeUniqueOption
      getValues getFiles
      optionAttrSetToDocList optionAttrSetToDocList'
      scrubOptionValue literalExpression literalExample literalDocBook
      showOption showFiles unknownModule mkOption mkPackageOption;
    inherit (self.types) isType setType defaultTypeMerge defaultFunctor
      isOptionType mkOptionType;
    inherit (self.asserts)
      assertMsg assertOneOf;
    inherit (self.debug) addErrorContextToAttrs traceIf traceVal traceValFn
      traceXMLVal traceXMLValMarked traceSeq traceSeqN traceValSeq
      traceValSeqFn traceValSeqN traceValSeqNFn traceFnSeqN traceShowVal
      traceShowValMarked showVal traceCall traceCall2 traceCall3
      traceValIfNot runTests testAllTrue traceCallXml attrNamesToStr;
    inherit (self.misc) maybeEnv defaultMergeArg defaultMerge foldArgs
      maybeAttrNullable maybeAttr ifEnable checkFlag getValue
      checkReqs uniqList uniqListExt condConcat lazyGenericClosure
      innerModifySumArgs modifySumArgs innerClosePropagation
      closePropagation mapAttrsFlatten nvs setAttr setAttrMerge
      mergeAttrsWithFunc mergeAttrsConcatenateValues
      mergeAttrsNoOverride mergeAttrByFunc mergeAttrsByFuncDefaults
      mergeAttrsByFuncDefaultsClean mergeAttrBy
      fakeHash fakeSha256 fakeSha512
      nixType imap;
    inherit (self.versions)
      splitVersion;
  });
in lib
