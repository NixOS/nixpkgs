/**
  Tests for lib.customisation functions (mkPackageVariants, etc.).

  To run these tests:

    [nixpkgs]$ nix-instantiate --eval --strict lib/tests/customisation.nix

  If the resulting list is empty, all tests passed.
*/

let
  lib = import ../default.nix;

  inherit (lib)
    attrNames
    callPackageWith
    mkPackageVariants
    runTests
    ;

  testingThrow = expr: {
    expr = (builtins.tryEval (builtins.seq expr "didn't throw"));
    expected = {
      success = false;
      value = false;
    };
  };

  # Mock derivation with overrideAttrs support
  mkMockDrv =
    attrs:
    attrs
    // {
      overrideAttrs = f: mkMockDrv (attrs // (f attrs));
      type = "derivation";
    };

  # Standard mock scope providing the dependencies that callPackageWith resolves
  mockScope = {
    inherit lib;
    inherit (lib) versionOlder versionAtLeast;
    mockDep = "resolved";
  };

  mockCallPackage = callPackageWith mockScope;

  # Attrs injected by mkPackageVariants into variantArgs (not package-specific)
  variantArgsInfra = [
    "mkVariantPassthru"
    "packageOlder"
    "packageAtLeast"
    "packageBetween"
  ];

  # Standard mock generic builder: variantArgs -> packageArgs -> mock derivation
  # Extra variant attrs (beyond version/hash/infra) are passed through to passthru.
  mockGenericBuilder =
    { version, ... }@variantArgs:
    { ... }:
    mkMockDrv {
      name = "test-${version}";
      passthru = builtins.removeAttrs variantArgs (
        [
          "version"
          "hash"
        ]
        ++ variantArgsInfra
      );
    };

  # Pre-bound mkPackageVariants with standard mocks
  mkVariants = mkPackageVariants {
    callPackage = mockCallPackage;
    allowAliases = true;
  };

  mkVariantsNoAliases = mkPackageVariants {
    callPackage = mockCallPackage;
    allowAliases = false;
  };

  # Standard two-variant test set
  testVariants = {
    v1 = {
      version = "1.0";
      hash = "aaa";
    };
    v2 = {
      version = "2.0";
      hash = "bbb";
    };
  };

  # Standard test package (default = v1)
  pkg = mkVariants { } {
    defaultVariant = p: p.v1;
    variants = testVariants;
    genericBuilder = mockGenericBuilder;
  };

  # Shorthand for the default variant's variantArgs
  va = pkg.passthru.variantArgs;
in

runTests {

  # Default variant selection

  testMkPackageVariantsDefaultSelection = {
    expr = pkg.name;
    expected = "test-1.0";
  };

  # Passthru: individual variants

  testMkPackageVariantsAllVariantsInPassthru = {
    expr = {
      hasV1 = pkg.passthru ? v1;
      hasV2 = pkg.passthru ? v2;
      v1Name = pkg.passthru.v1.name;
      v2Name = pkg.passthru.v2.name;
    };
    expected = {
      hasV1 = true;
      hasV2 = true;
      v1Name = "test-1.0";
      v2Name = "test-2.0";
    };
  };

  # Passthru: variants attrset

  testMkPackageVariantsVariantsAttr = {
    expr = {
      hasVariants = pkg.passthru ? variants;
      variantNames = attrNames pkg.passthru.variants;
    };
    expected = {
      hasVariants = true;
      variantNames = [
        "v1"
        "v2"
      ];
    };
  };

  # Passthru: variantArgs

  testMkPackageVariantsVariantArgs = {
    expr = va.version;
    expected = "1.0";
  };

  # Helper functions

  testMkPackageVariantsPackageOlder = {
    expr = {
      olderThan2 = va.packageOlder "2.0";
      olderThan1 = va.packageOlder "1.0";
    };
    expected = {
      olderThan2 = true;
      olderThan1 = false;
    };
  };

  testMkPackageVariantsPackageAtLeast = {
    expr = {
      atLeast1 = va.packageAtLeast "1.0";
      atLeast2 = va.packageAtLeast "2.0";
    };
    expected = {
      atLeast1 = true;
      atLeast2 = false;
    };
  };

  testMkPackageVariantsPackageBetween = {
    expr = {
      between05and15 = va.packageBetween "0.5" "1.5";
      between15and25 = va.packageBetween "1.5" "2.5";
      between05and10 = va.packageBetween "0.5" "1.0";
    };
    expected = {
      between05and15 = true;
      between15and25 = false;
      between05and10 = false;
    };
  };

  # Aliases

  testMkPackageVariantsAliases =
    let
      aliasPkg = mkVariants { } {
        defaultVariant = p: p.v1;
        variants = testVariants;
        genericBuilder = mockGenericBuilder;
        aliases = {
          old = testVariants.v1;
        };
      };
    in
    {
      expr = {
        hasAlias = aliasPkg.passthru ? old;
        aliasName = aliasPkg.passthru.old.name;
      };
      expected = {
        hasAlias = true;
        aliasName = "test-1.0";
      };
    };

  testMkPackageVariantsNoAliases =
    let
      noAliasPkg = mkVariantsNoAliases { } {
        defaultVariant = p: p.v1;
        variants = testVariants;
        genericBuilder = mockGenericBuilder;
        aliases = {
          old = testVariants.v1;
        };
      };
    in
    {
      expr = noAliasPkg.passthru ? old;
      expected = false;
    };

  testMkPackageVariantsAliasesFunction =
    let
      fnAliasPkg = mkVariants { } {
        defaultVariant = p: p.v1;
        variants = testVariants;
        genericBuilder = mockGenericBuilder;
        aliases =
          { lib, variants }:
          {
            latest = variants.v2;
          };
      };
    in
    {
      expr = {
        hasLatest = fnAliasPkg.passthru ? latest;
        latestName = fnAliasPkg.passthru.latest.name;
      };
      expected = {
        hasLatest = true;
        latestName = "test-2.0";
      };
    };

  # Override args filtering and forwarding

  testMkPackageVariantsOverrideArgsFiltering =
    let
      filterScope = mockScope // {
        mkPackageVariants = "should-be-filtered";
        override = "should-be-filtered";
        overrideDerivation = "should-be-filtered";
        overrideAttrs = "should-be-filtered";
      };
      # Builder accepts infrastructure attr names as optional args;
      # if filtering works, they come from scope (strings), not outerArgs.
      filterGenericBuilder =
        { version, ... }:
        {
          mkPackageVariants ? "from-scope",
          override ? "from-scope",
          overrideDerivation ? "from-scope",
          overrideAttrs ? "from-scope",
        }:
        mkMockDrv {
          name = "test-${version}";
          passthru = {
            receivedMkPV = mkPackageVariants;
            receivedOverride = override;
            receivedOverrideDerivation = overrideDerivation;
            receivedOverrideAttrs = overrideAttrs;
          };
        };
      filterMkVariants = lib.mkPackageVariants {
        callPackage = callPackageWith filterScope;
        allowAliases = true;
      };
      # Pass infrastructure args in outerArgs — they should be filtered out
      filterPkg =
        filterMkVariants
          {
            mkPackageVariants = "outer-value";
            override = "outer-value";
            overrideDerivation = "outer-value";
            overrideAttrs = "outer-value";
          }
          {
            defaultVariant = p: p.v1;
            variants = testVariants;
            genericBuilder = filterGenericBuilder;
          };
    in
    {
      expr = {
        inherit (filterPkg.passthru)
          receivedMkPV
          receivedOverride
          receivedOverrideDerivation
          receivedOverrideAttrs
          ;
      };
      expected = {
        receivedMkPV = "should-be-filtered";
        receivedOverride = "should-be-filtered";
        receivedOverrideDerivation = "should-be-filtered";
        receivedOverrideAttrs = "should-be-filtered";
      };
    };

  testMkPackageVariantsOuterArgsForwarding =
    let
      extraGenericBuilder =
        { version, ... }:
        {
          extraArg ? "default",
          ...
        }:
        mkMockDrv {
          name = "test-${version}";
          passthru = {
            inherit extraArg;
          };
        };
      extraPkg = mkVariants { extraArg = "custom"; } {
        defaultVariant = p: p.v1;
        variants = testVariants;
        genericBuilder = extraGenericBuilder;
      };
    in
    {
      expr = extraPkg.passthru.extraArg;
      expected = "custom";
    };

  testMkPackageVariantsPerVariantOverrideArgs =
    let
      featureGenericBuilder =
        { version, ... }:
        {
          feature ? "off",
          ...
        }:
        mkMockDrv {
          name = "test-${version}";
          passthru = {
            inherit feature;
          };
        };
      featurePkg = mkVariants { } {
        defaultVariant = p: p.v1;
        variants = {
          v1 = {
            version = "1.0";
            hash = "aaa";
          };
          v1_feature = {
            version = "1.0";
            hash = "aaa";
            overrideArgs = {
              feature = "on";
            };
          };
        };
        genericBuilder = featureGenericBuilder;
      };
    in
    {
      expr = {
        v1Feature = featurePkg.passthru.v1.passthru.feature;
        v1FeatureVariant = featurePkg.passthru.v1_feature.passthru.feature;
      };
      expected = {
        v1Feature = "off";
        v1FeatureVariant = "on";
      };
    };

  # Assertion: defaultVariant must be a function

  testMkPackageVariantsDefaultVariantNotFunction = testingThrow (
    mkVariants { } {
      defaultVariant = "not-a-function";
      variants = testVariants;
      genericBuilder = mockGenericBuilder;
    }
  );

  # Variant-specific fields override selectedVariant defaults
  # mockGenericBuilder passes extra variantArgs (like extraField) through to passthru

  testMkPackageVariantsVariantOverridesDefault =
    let
      overridePkg = mkVariants { } {
        defaultVariant = p: p.v1;
        variants = {
          v1 = {
            version = "1.0";
            hash = "aaa";
            extraField = "from-default";
          };
          v2 = {
            version = "2.0";
            hash = "bbb";
            extraField = "from-v2";
          };
        };
        genericBuilder = mockGenericBuilder;
      };
    in
    {
      expr = {
        v1Extra = overridePkg.passthru.v1.passthru.extraField;
        v2Extra = overridePkg.passthru.v2.passthru.extraField;
      };
      expected = {
        v1Extra = "from-default";
        v2Extra = "from-v2";
      };
    };
}
