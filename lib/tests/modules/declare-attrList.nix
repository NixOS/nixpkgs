# Run with:
#   cd nixpkgs
#   ./lib/tests/modules.sh
{ lib, config, ... }:
let
  inherit (lib)
    mkOption
    mkOrder
    mkMerge
    mkBefore
    mkAfter
    mkIf
    mkOverride
    mkDefault
    mkForce
    types
    ;
in
{
  options = {
    attrList = mkOption {
      type = types.lazyAttrsOf (types.attrListOf types.str);
    };

    attrListInt = mkOption {
      type = types.lazyAttrsOf (types.attrListOf types.int);
    };

    attrListSubmodule = mkOption {
      type = types.attrListOf (
        types.submodule {
          options.port = mkOption {
            type = types.int;
            description = "Port number";
          };
          options.host = mkOption {
            type = types.str;
            default = "localhost";
            description = "Hostname";
          };
        }
      );
    };

    # asAttrs: value is a merged attrset, ordered list in valueMeta
    asAttrs = mkOption {
      type = types.lazyAttrsOf (
        types.attrListWith {
          elemType = types.str;
          asAttrs = true;
          mergeAttrValues = _name: values: lib.last values;
        }
      );
    };

    # asAttrs with default mergeAttrValues: duplicates collected into lists
    asAttrsDefault = mkOption {
      type = types.lazyAttrsOf (
        types.attrListWith {
          elemType = types.int;
          asAttrs = true;
        }
      );
    };

    # Strict wrappers that force deep evaluation, for testing error cases
    attrListStrict = mkOption {
      type = types.lazyAttrsOf types.raw;
    };

    attrListIntStrict = mkOption {
      type = types.lazyAttrsOf types.raw;
    };

    # either picks attrList when input is list/attrset, int when input is int
    eitherAttrListOrInt = mkOption {
      type = types.either (types.attrListOf types.str) types.int;
    };

    eitherAttrListOrIntFallback = mkOption {
      type = types.either (types.attrListOf types.str) types.int;
    };

    eitherIntOrAttrList = mkOption {
      type = types.either types.int (types.attrListOf types.str);
    };

    eitherIntOrAttrListFallback = mkOption {
      type = types.either types.int (types.attrListOf types.str);
    };

    assertions = mkOption { };
  };

  imports = [
    # Second module contributing to multiModule
    {
      attrListInt.multiModule = [
        { b = 2; }
      ];
    }
  ];

  config = {

    # List input: pass-through
    attrList.listInput = [
      { a = "alpha"; }
      { b = "beta"; }
    ];

    # Attrset input with explicit ordering
    attrList.attrsetOrdered = {
      x = mkOrder 200 "x-val";
      y = mkOrder 100 "y-val";
    };

    # Mixed: list elements at default priority, attrset with mkOrder
    attrList.mixed = mkMerge [
      [
        { m = "from-list"; }
      ]
      {
        n = mkOrder 50 "from-attrset";
      }
    ];

    # Multiple list definitions from separate modules
    attrListInt.multiModule = [
      { a = 1; }
    ];

    # Attrset without mkOrder uses default priority
    attrList.attrsetNoOrder = {
      foo = "bar";
      baz = "qux";
    };

    # Empty list
    attrList.empty = [ ];

    # Ordering test: lower priority first
    attrList.ordering = mkMerge [
      {
        last = mkOrder 1500 "last";
      }
      {
        first = mkOrder 500 "first";
      }
      [
        { middle = "middle"; }
      ]
    ];

    # List elements support mkOrder/mkBefore/mkAfter
    attrList.listOrdering = [
      (mkAfter { z = "after"; })
      { m = "default"; }
      (mkBefore { a = "before"; })
    ];

    # Plain list entries land at default priority (1000):
    # they appear after mkOrder 999 and before mkOrder 1001.
    attrList.listDefaultPrio = mkMerge [
      { after = mkOrder 1001 "after"; }
      [
        { mid = "list-entry"; }
      ]
      { before = mkOrder 999 "before"; }
    ];

    # mkBefore and mkAfter
    attrList.beforeAfter = mkMerge [
      {
        z = mkAfter "after";
      }
      {
        a = mkBefore "before";
      }
      [
        { m = "default"; }
      ]
    ];

    # mkIf: conditional definition
    attrList.withMkIf = mkMerge [
      (mkIf true [
        { yes = "included"; }
      ])
      (mkIf false [
        { no = "excluded"; }
      ])
    ];

    # mkOverride: higher priority override wins
    attrList.withOverride = mkMerge [
      (mkOverride 100 [
        { replaced = "gone"; }
      ])
      (mkOverride 50 [
        { winner = "wins"; }
      ])
    ];

    # mkDefault: lower priority than normal
    attrList.withDefault = mkMerge [
      (mkDefault [
        { default = "overridden"; }
      ])
      [
        { normal = "wins"; }
      ]
    ];

    # mkForce on the whole option (should discard other defs)
    attrList.withForce = mkMerge [
      [
        { discarded = "gone"; }
      ]
      (mkForce [
        { forced = "wins"; }
      ])
    ];

    # mkForce with mkOrder inside
    attrList.forceWithOrder = mkForce [
      (mkAfter { second = "after"; })
      (mkBefore { first = "before"; })
    ];

    # mkForce on individual element values; non-forced entries are discarded.
    # Discarded values use a mix of: plain value, mkDefault(abort ...), mkOverride 100 (abort ...).
    # The abort variants verify laziness: peelProperties sees the wrapper without forcing the content.
    attrListInt.forceElementValue = [
      { a = mkDefault (abort "overridden by mkForce; laziness guarantee: MUST NOT be evaluated"); }
      { a = mkForce 42; }
      { a = mkOverride 100 (abort "overridden by mkForce; laziness guarantee: MUST NOT be evaluated"); }
      { b = 2; }
    ];

    # mkForce on attrset format
    attrList.forceAttrset = mkMerge [
      [
        { discarded = "gone"; }
      ]
      (mkForce {
        x = mkOrder 200 "x-val";
        y = mkOrder 100 "y-val";
      })
    ];

    # mkForce on repeated key: forced entries override non-forced
    attrList.forceRepeatedKey = [
      { x = mkOverride 100 (abort "overridden by mkForce; laziness guarantee: MUST NOT be evaluated"); }
      { x = mkForce "wins"; }
      { x = mkForce "wins 2"; }
    ];

    # mkForce on repeated key across mkMerge
    attrList.forceRepeatedKeyMerge = mkMerge [
      [
        { x = "unused: overridden by mkForce"; }
        { x = mkDefault (abort "overridden by mkForce; laziness guarantee: MUST NOT be evaluated"); }
      ]
      [
        { x = mkOverride 100 (abort "overridden by mkForce; laziness guarantee: MUST NOT be evaluated"); }
      ]
      [
        { x = mkForce "forced"; }
      ]
    ];

    # mkForce on repeated key in attrset format across mkMerge
    attrList.forceRepeatedKeyAttrs = mkMerge [
      {
        x = mkDefault (abort "overridden by mkForce; laziness guarantee: MUST NOT be evaluated");
        y = "kept";
      }
      { x = mkForce "forced"; }
    ];

    # mkForce only affects the key it's on, other keys survive
    attrList.forcePartialAttrs = mkMerge [
      {
        x = "unused: overridden by mkForce";
        y = "normal y";
      }
      { x = mkForce "forced x"; }
    ];

    # mkForce in attrset format overrides same key from list format
    attrList.forceMixedFormats = mkMerge [
      [
        { x = mkOverride 100 (abort "overridden by mkForce; laziness guarantee: MUST NOT be evaluated"); }
        { y = "list y"; }
      ]
      { x = mkForce "attrset forced x"; }
    ];

    # Nesting: list format, mkOrder on element + mkForce on value
    attrList.nestListOrderForce = mkMerge [
      [
        { x = mkDefault (abort "overridden by mkForce; laziness guarantee: MUST NOT be evaluated"); }
        (mkOrder 500 { x = mkForce "forced-early"; })
        (mkOrder 1500 { y = "late"; })
      ]
      [
        (mkOrder 100 { z = "earliest"; })
      ]
    ];

    # Nesting: list format, mkOrder(mkForce(val)) on value
    attrList.nestListOrderOfForce = mkMerge [
      [
        { x = mkOverride 100 (abort "overridden by mkForce; laziness guarantee: MUST NOT be evaluated"); }
        { y = "plain-early"; }
      ]
      [
        { x = mkOrder 1500 (mkForce "forced-late"); }
        { z = mkOrder 500 "earliest"; }
      ]
      [
        { x = "unused: overridden by mkForce"; }
        { w = mkOrder 1200 "mid"; }
      ]
    ];

    # Nesting: list format, mkForce(mkOrder(val)) on value
    attrList.nestListForceOfOrder = mkMerge [
      [
        { x = "unused: overridden by mkForce"; }
        { y = "plain-early"; }
      ]
      [
        { x = mkForce (mkOrder 1500 "forced-late"); }
        { z = mkOrder 500 "earliest"; }
      ]
      [
        { x = mkDefault (abort "overridden by mkForce; laziness guarantee: MUST NOT be evaluated"); }
        { w = mkOrder 1200 "mid"; }
      ]
    ];

    # Nesting: attrset format, mkOrder wrapping mkForce
    attrList.nestAttrsOrderOfForce = mkMerge [
      {
        x = mkOverride 100 (abort "overridden by mkForce; laziness guarantee: MUST NOT be evaluated");
        y = "plain-early";
      }
      {
        x = mkOrder 1500 (mkForce "forced-late");
        z = mkOrder 500 "earliest";
      }
      {
        x = "unused: overridden by mkForce";
        w = mkOrder 1200 "mid";
      }
    ];

    # Nesting: attrset format, mkForce wrapping mkOrder
    attrList.nestAttrsForceOfOrder = mkMerge [
      {
        x = "unused: overridden by mkForce";
        y = "plain-early";
      }
      {
        x = mkForce (mkOrder 1500 "forced-late");
        z = mkOrder 500 "earliest";
      }
      {
        x = mkDefault (abort "overridden by mkForce; laziness guarantee: MUST NOT be evaluated");
        w = mkOrder 1200 "mid";
      }
    ];

    # mkIf false on individual element value filters it out (list format)
    attrListInt.optionalValueList = [
      { a = mkIf true 1; }
      { b = mkIf false 2; }
      { c = 3; }
    ];

    # mkIf false on individual element value filters it out (attrset format)
    attrListInt.optionalValueAttrs = {
      a = mkIf true 1;
      b = mkIf false 2;
      c = 3;
    };

    # submodule elemType: produces real valueMeta
    attrListSubmodule = [
      {
        web = {
          port = 80;
        };
      }
      {
        db = {
          port = 5432;
          host = "dbhost";
        };
      }
    ];

    # asAttrs: unique keys — value is a plain attrset
    asAttrs.unique = [
      { a = "alpha"; }
      { b = "beta"; }
    ];

    # asAttrs: duplicate keys — last in order wins
    asAttrs.duplicateKeys = mkMerge [
      { x = mkOrder 500 "first"; }
      { x = mkOrder 1500 "last"; }
      { y = "only"; }
    ];

    # asAttrs: with ordering — value is attrset, ordered list in valueMeta
    asAttrs.ordered = {
      z = mkOrder 200 "z-val";
      a = mkOrder 100 "a-val";
    };

    # asAttrs: with mkForce — forced key overrides
    asAttrs.withForce = mkMerge [
      { x = "unused: overridden by mkForce"; }
      {
        x = mkForce "forced";
        y = "kept";
      }
    ];

    # asAttrs: empty
    asAttrs.empty = [ ];

    # asAttrsDefault: unique keys
    asAttrsDefault.unique = [
      { a = 1; }
      { b = 2; }
    ];

    # asAttrsDefault: duplicate keys — default collects into lists
    asAttrsDefault.duplicates = mkMerge [
      { x = mkOrder 500 10; }
      { x = mkOrder 1500 30; }
      { y = 99; }
      [
        { x = 20; }
      ]
    ];

    # either: attrList branch matches for list input
    eitherAttrListOrInt = [
      { a = "hello"; }
      { b = "world"; }
    ];

    # either: int input falls through to int branch
    eitherAttrListOrIntFallback = 42;

    # either (swapped): int first, attrList second — int input matches int
    eitherIntOrAttrList = 42;

    # either (swapped): list input falls through to attrList branch
    eitherIntOrAttrListFallback = [
      { a = "hello"; }
    ];

    # Bad: string where int expected
    attrListInt.badValue = [
      { a = "not-an-int"; }
    ];

    # Bad: list element with multiple keys
    attrList.badListElem = [
      {
        a = "ok";
        b = "extra";
      }
    ];

    # Bad: plain string instead of list or attrset
    attrList.badString = "not-a-container";

    # Bad: list element is a bare string, not a singleton attrset
    attrList.badListString = [
      "not a singleton attribute"
    ];

    attrListStrict = builtins.mapAttrs (k: v: builtins.deepSeq v v) config.attrList;
    attrListIntStrict = builtins.mapAttrs (k: v: builtins.deepSeq v v) config.attrListInt;

    assertions =
      let
        c = lib.evalModules {
          modules = [ ./declare-attrList.nix ];
        };
        cfg = c.config;
      in

      # List input preserves elements
      assert
        cfg.attrList.listInput == [
          { a = "alpha"; }
          { b = "beta"; }
        ];

      # Attrset input with mkOrder: lower priority comes first
      assert
        cfg.attrList.attrsetOrdered == [
          { y = "y-val"; }
          { x = "x-val"; }
        ];

      # Mixed input: mkOrder 50 < default 1000
      assert
        cfg.attrList.mixed == [
          { n = "from-attrset"; }
          { m = "from-list"; }
        ];

      # Multiple definitions from separate modules concatenate
      # (import module's definition comes before this module's)
      assert
        cfg.attrListInt.multiModule == [
          { b = 2; }
          { a = 1; }
        ];

      # Attrset without mkOrder: all at default priority
      assert builtins.length cfg.attrList.attrsetNoOrder == 2;

      # Empty list stays empty
      assert cfg.attrList.empty == [ ];

      # List elements support mkOrder/mkBefore/mkAfter
      assert
        cfg.attrList.listOrdering == [
          { a = "before"; }
          { m = "default"; }
          { z = "after"; }
        ];

      # Plain list entries are at default priority (1000)
      assert
        cfg.attrList.listDefaultPrio == [
          { before = "before"; }
          { mid = "list-entry"; }
          { after = "after"; }
        ];

      # Ordering: 500 < 1000 (default) < 1500
      assert
        cfg.attrList.ordering == [
          { first = "first"; }
          { middle = "middle"; }
          { last = "last"; }
        ];

      # mkBefore (500) < default (1000) < mkAfter (1500)
      assert
        cfg.attrList.beforeAfter == [
          { a = "before"; }
          { m = "default"; }
          { z = "after"; }
        ];

      # mkIf true includes, mkIf false excludes
      assert
        cfg.attrList.withMkIf == [
          { yes = "included"; }
        ];

      # mkOverride: only lowest priority override survives
      assert
        cfg.attrList.withOverride == [
          { winner = "wins"; }
        ];

      # mkDefault is overridden by normal definitions
      assert
        cfg.attrList.withDefault == [
          { normal = "wins"; }
        ];

      # mkForce discards other definitions
      assert
        cfg.attrList.withForce == [
          { forced = "wins"; }
        ];

      # mkForce with mkOrder inside: ordering still works
      assert
        cfg.attrList.forceWithOrder == [
          { first = "before"; }
          { second = "after"; }
        ];

      # mkForce on individual element values passes through
      assert
        cfg.attrListInt.forceElementValue == [
          { a = 42; }
          { b = 2; }
        ];

      # mkForce on attrset format: discards other defs, ordering preserved
      assert
        cfg.attrList.forceAttrset == [
          { y = "y-val"; }
          { x = "x-val"; }
        ];

      # mkForce on repeated key: forced entries override non-forced
      assert
        cfg.attrList.forceRepeatedKey == [
          { x = "wins"; }
          { x = "wins 2"; }
        ];

      # mkForce on repeated key across mkMerge: forced wins
      assert
        cfg.attrList.forceRepeatedKeyMerge == [
          { x = "forced"; }
        ];

      # mkForce on repeated key in attrset format: discards other x, keeps y
      assert
        cfg.attrList.forceRepeatedKeyAttrs == [
          { y = "kept"; }
          { x = "forced"; }
        ];

      # mkForce only affects its own key
      assert
        cfg.attrList.forcePartialAttrs == [
          { y = "normal y"; }
          { x = "forced x"; }
        ];

      # mkForce in attrset format overrides same key from list format
      assert
        cfg.attrList.forceMixedFormats == [
          { y = "list y"; }
          { x = "attrset forced x"; }
        ];

      # Nesting: list format, mkOrder on element + mkForce on value
      # z(100) < x-forced(500) < y(1500); x-discarded filtered by mkForce
      assert
        cfg.attrList.nestListOrderForce == [
          { z = "earliest"; }
          { x = "forced-early"; }
          { y = "late"; }
        ];

      # Nesting: list format, mkOrder(mkForce(val)) on value
      # z(500) < y(1000) < w(1200) < x-forced(1500); x-discarded entries filtered
      assert
        cfg.attrList.nestListOrderOfForce == [
          { z = "earliest"; }
          { y = "plain-early"; }
          { w = "mid"; }
          { x = "forced-late"; }
        ];

      # Nesting: list format, mkForce(mkOrder(val)) on value
      # z(500) < y(1000) < w(1200) < x-forced(1500); x-discarded entries filtered
      assert
        cfg.attrList.nestListForceOfOrder == [
          { z = "earliest"; }
          { y = "plain-early"; }
          { w = "mid"; }
          { x = "forced-late"; }
        ];

      # Nesting: attrset format, mkOrder(mkForce(val))
      # z(500) < y(1000) < w(1200) < x-forced(1500); x-discarded entries filtered
      assert
        cfg.attrList.nestAttrsOrderOfForce == [
          { z = "earliest"; }
          { y = "plain-early"; }
          { w = "mid"; }
          { x = "forced-late"; }
        ];

      # Nesting: attrset format, mkForce(mkOrder(val))
      # z(500) < y(1000) < w(1200) < x-forced(1500); x-discarded entries filtered
      assert
        cfg.attrList.nestAttrsForceOfOrder == [
          { z = "earliest"; }
          { y = "plain-early"; }
          { w = "mid"; }
          { x = "forced-late"; }
        ];

      # mkIf false on individual element value filters it out (list format)
      assert
        cfg.attrListInt.optionalValueList == [
          { a = 1; }
          { c = 3; }
        ];

      # mkIf false on individual element value filters it out (attrset format)
      assert
        cfg.attrListInt.optionalValueAttrs == [
          { a = 1; }
          { c = 3; }
        ];

      # submodule: value, option descriptions, and valueMeta with real configuration metadata
      assert
        cfg.attrListSubmodule == [
          {
            web = {
              host = "localhost";
              port = 80;
            };
          }
          {
            db = {
              host = "dbhost";
              port = 5432;
            };
          }
        ];
      assert
        builtins.map (m: m.configuration.config) c.options.attrListSubmodule.valueMeta.attrList == [
          {
            host = "localhost";
            port = 80;
          }
          {
            host = "dbhost";
            port = 5432;
          }
        ];
      assert
        builtins.map (
          m:
          builtins.mapAttrs (n: o: o.description) (builtins.removeAttrs m.configuration.options [ "_module" ])
        ) c.options.attrListSubmodule.valueMeta.attrList == [
          {
            host = "Hostname";
            port = "Port number";
          }
          {
            host = "Hostname";
            port = "Port number";
          }
        ];

      # valueMeta.attrList has one entry per (non-filtered) element
      assert
        c.options.attrList.valueMeta.attrs.listInput.attrList == [
          { }
          { }
        ];
      assert
        c.options.attrList.valueMeta.attrs.attrsetOrdered.attrList == [
          { }
          { }
        ];
      assert
        c.options.attrList.valueMeta.attrs.mixed.attrList == [
          { }
          { }
        ];
      assert c.options.attrList.valueMeta.attrs.empty.attrList == [ ];
      assert
        c.options.attrListInt.valueMeta.attrs.optionalValueList.attrList == [
          { }
          { }
        ];

      # either: headError is null for valid attrList input, so attrList branch is picked
      assert
        cfg.eitherAttrListOrInt == [
          { a = "hello"; }
          { b = "world"; }
        ];

      # either: headError is non-null for int input, so int branch is picked
      assert cfg.eitherAttrListOrIntFallback == 42;

      # either (swapped): int first — int input matches
      assert cfg.eitherIntOrAttrList == 42;

      # either (swapped): list input falls through to attrList branch
      assert
        cfg.eitherIntOrAttrListFallback == [
          { a = "hello"; }
        ];

      # asAttrs: unique keys — value is a plain attrset
      assert
        cfg.asAttrs.unique == {
          a = "alpha";
          b = "beta";
        };
      # ordered list preserved in valueMeta
      assert
        c.options.asAttrs.valueMeta.attrs.unique.attrListValue == [
          { a = "alpha"; }
          { b = "beta"; }
        ];

      # asAttrs: duplicate keys — last in order wins
      assert
        cfg.asAttrs.duplicateKeys == {
          x = "last";
          y = "only";
        };
      assert
        c.options.asAttrs.valueMeta.attrs.duplicateKeys.attrListValue == [
          { x = "first"; }
          { y = "only"; }
          { x = "last"; }
        ];

      # asAttrs: ordered — value is attrset (unordered), list in valueMeta preserves order
      assert
        cfg.asAttrs.ordered == {
          a = "a-val";
          z = "z-val";
        };
      assert
        c.options.asAttrs.valueMeta.attrs.ordered.attrListValue == [
          { a = "a-val"; }
          { z = "z-val"; }
        ];

      # asAttrs: mkForce — forced key overrides, value is attrset
      assert
        cfg.asAttrs.withForce == {
          x = "forced";
          y = "kept";
        };

      # asAttrs: empty — value is empty attrset
      assert cfg.asAttrs.empty == { };

      # asAttrsDefault: unique keys — each value wrapped in singleton list
      assert
        cfg.asAttrsDefault.unique == {
          a = [ 1 ];
          b = [ 2 ];
        };

      # asAttrsDefault: duplicate keys — values collected into list in order
      assert
        cfg.asAttrsDefault.duplicates == {
          x = [
            10
            20
            30
          ];
          y = [ 99 ];
        };
      assert
        c.options.asAttrsDefault.valueMeta.attrs.duplicates.attrListValue == [
          { x = 10; }
          { y = 99; }
          { x = 20; }
          { x = 30; }
        ];

      # valueMeta.definitions: mkDefinition records with mkOrder-wrapped single-key attrsets
      # Use duplicateKeys which has mixed priorities and repeated keys
      assert
        let
          defs = c.options.asAttrs.valueMeta.attrs.duplicateKeys.definitions;
          extract = d: {
            prio = d.value.priority;
            value = d.value.content;
          };
        in
        map extract defs == [
          {
            prio = 500;
            value = {
              x = "first";
            };
          }
          {
            prio = 1000;
            value = {
              y = "only";
            };
          }
          {
            prio = 1500;
            value = {
              x = "last";
            };
          }
        ];

      # Round-trip: feed definitions through mapDefinitionValue + mkMerge into a listOf option
      assert
        let
          rendered = lib.modules.mapDefinitionValue (attr: lib.cli.toCommandLineGNU { } attr) (
            mkMerge c.options.asAttrs.valueMeta.attrs.duplicateKeys.definitions
          );
          result =
            (lib.evalModules {
              modules = [
                { options.out = mkOption { type = types.listOf types.str; }; }
                { config.out = rendered; }
                # Interleave: mkOrder 800 lands between x(500) and y(1000)
                { config.out = mkOrder 800 [ "--interleaved" ]; }
              ];
            }).config.out;
        in
        result == [
          "-xfirst"
          "--interleaved"
          "-yonly"
          "-xlast"
        ];

      # Error cases are tested via checkConfigError in modules.sh

      "ok";
  };
}
