{
  pkgs ? import ../.. { },
  currLibPath ? ../.,
  prevLibPath ? "${
    pkgs.fetchFromGitHub {
      owner = "nixos";
      repo = "nixpkgs";
      # Parent commit of [#391544](https://github.com/NixOS/nixpkgs/pull/391544)
      # Which was before the type.merge.v2 introduction
      rev = "bcf94dd3f07189b7475d823c8d67d08b58289905";
      hash = "sha256-MuMiIY3MX5pFSOCvutmmRhV6RD0R3CG0Hmazkg8cMFI=";
    }
  }/lib",
}:
let
  lib = import currLibPath;

  lib_with_merge_v2 = lib;
  lib_with_merge_v1 = import prevLibPath;

  getMatrix =
    {
      getType ? null,
      # If getType is set this is only used as test prefix
      # And the type from getType is used
      outerTypeName,
      innerTypeName,
      value,
      testAttrs,
    }:
    let
      evalModules.call_v1 = lib_with_merge_v1.evalModules;
      evalModules.call_v2 = lib_with_merge_v2.evalModules;
      outerTypes.outer_v1 = lib_with_merge_v1.types;
      outerTypes.outer_v2 = lib_with_merge_v2.types;
      innerTypes.inner_v1 = lib_with_merge_v1.types;
      innerTypes.inner_v2 = lib_with_merge_v2.types;
    in
    lib.mapAttrs (
      _: evalModules:
      lib.mapAttrs (
        _: outerTypes:
        lib.mapAttrs (_: innerTypes: {
          "test_${outerTypeName}_${innerTypeName}" = testAttrs // {
            expr =
              (evalModules {
                modules = [
                  (m: {
                    options.foo = m.lib.mkOption {
                      type =
                        if getType != null then
                          getType outerTypes innerTypes
                        else
                          outerTypes.${outerTypeName} innerTypes.${innerTypeName};
                      default = value;
                    };
                  })
                ];
              }).config.foo;
          };
        }) innerTypes
      ) outerTypes
    ) evalModules;
in
{
  # AttrsOf string
  attrsOf_str_ok = getMatrix {
    outerTypeName = "attrsOf";
    innerTypeName = "str";
    value = {
      bar = "test";
    };
    testAttrs = {
      expected = {
        bar = "test";
      };
    };
  };
  attrsOf_str_err_inner = getMatrix {
    outerTypeName = "attrsOf";
    innerTypeName = "str";
    value = {
      bar = 1; # not a string
    };
    testAttrs = {
      expectedError = {
        type = "ThrownError";
        msg = "A definition for option `foo.bar' is not of type `string'.*";
      };
    };
  };
  attrsOf_str_err_outer = getMatrix {
    outerTypeName = "attrsOf";
    innerTypeName = "str";
    value = [ "foo" ]; # not an attrset
    testAttrs = {
      expectedError = {
        type = "ThrownError";
        msg = "A definition for option `foo' is not of type `attribute set of string'.*";
      };
    };
  };

  # listOf string
  listOf_str_ok = getMatrix {
    outerTypeName = "listOf";
    innerTypeName = "str";
    value = [
      "foo"
      "bar"
    ];
    testAttrs = {
      expected = [
        "foo"
        "bar"
      ];
    };
  };
  listOf_str_err_inner = getMatrix {
    outerTypeName = "listOf";
    innerTypeName = "str";
    value = [
      "foo"
      1
    ]; # not a string
    testAttrs = {
      expectedError = {
        type = "ThrownError";
        msg = ''A definition for option `foo."\[definition 1-entry 2\]"' is not of type `string'.'';
      };
    };
  };
  listOf_str_err_outer = getMatrix {
    outerTypeName = "listOf";
    innerTypeName = "str";
    value = {
      foo = 42;
    }; # not a list
    testAttrs = {
      expectedError = {
        type = "ThrownError";
        msg = "A definition for option `foo' is not of type `list of string'.*";
      };
    };
  };

  attrsOf_submodule_ok = getMatrix {
    getType =
      a: b:
      a.attrsOf (
        b.submodule (m: {
          options.nested = m.lib.mkOption {
            type = m.lib.types.str;
          };
        })
      );
    outerTypeName = "attrsOf";
    innerTypeName = "submodule";
    value = {
      foo = {
        nested = "test1";
      };
      bar = {
        nested = "test2";
      };
    };
    testAttrs = {
      expected = {
        foo = {
          nested = "test1";
        };
        bar = {
          nested = "test2";
        };
      };
    };
  };
  attrsOf_submodule_err_inner = getMatrix {
    outerTypeName = "attrsOf";
    innerTypeName = "submodule";
    getType =
      a: b:
      a.attrsOf (
        b.submodule (m: {
          options.nested = m.lib.mkOption {
            type = m.lib.types.str;
          };
        })
      );
    value = {
      foo = [ 1 ]; # not a submodule
      bar = {
        nested = "test2";
      };
    };
    testAttrs = {
      expectedError = {
        type = "ThrownError";
        msg = "A definition for option `foo.foo' is not of type `submodule'.*";
      };
    };
  };
  attrsOf_submodule_err_outer = getMatrix {
    outerTypeName = "attrsOf";
    innerTypeName = "submodule";
    getType =
      a: b:
      a.attrsOf (
        b.submodule (m: {
          options.nested = m.lib.mkOption {
            type = m.lib.types.str;
          };
        })
      );
    value = [ 123 ]; # not an attrsOf
    testAttrs = {
      expectedError = {
        type = "ThrownError";
        msg = ''A definition for option `foo' is not of type `attribute set of \(submodule\).*'';
      };
    };
  };

  # either
  either_str_attrsOf_ok = getMatrix {
    outerTypeName = "either";
    innerTypeName = "str_or_attrsOf_str";

    getType = a: b: a.either b.str (b.attrsOf a.str);
    value = "string value";
    testAttrs = {
      expected = "string value";
    };
  };
  either_str_attrsOf_err_1 = getMatrix {
    outerTypeName = "either";
    innerTypeName = "str_or_attrsOf_str";

    getType = a: b: a.either b.str (b.attrsOf a.str);
    value = 1;
    testAttrs = {
      expectedError = {
        type = "ThrownError";
        msg = "A definition for option `foo' is not of type `string or attribute set of string'.*";
      };
    };
  };
  either_str_attrsOf_err_2 = getMatrix {
    outerTypeName = "either";
    innerTypeName = "str_or_attrsOf_str";

    getType = a: b: a.either b.str (b.attrsOf a.str);
    value = {
      bar = 1; # not a string
    };
    testAttrs = {
      expectedError = {
        type = "ThrownError";
        msg = "A definition for option `foo.bar' is not of type `string'.*";
      };
    };
  };

  # Coereced to
  coerce_attrsOf_str_to_listOf_str_run = getMatrix {
    outerTypeName = "coercedTo";
    innerTypeName = "attrsOf_str->listOf_str";
    getType = a: b: a.coercedTo (b.attrsOf b.str) builtins.attrValues (b.listOf b.str);
    value = {
      bar = "test1"; # coerced to listOf string
      foo = "test2"; # coerced to listOf string
    };
    testAttrs = {
      expected = [
        "test1"
        "test2"
      ];
    };
  };
  coerce_attrsOf_str_to_listOf_str_final = getMatrix {
    outerTypeName = "coercedTo";
    innerTypeName = "attrsOf_str->listOf_str";
    getType = a: b: a.coercedTo (b.attrsOf b.str) (abort "This shouldnt run") (b.listOf b.str);
    value = [
      "test1"
      "test2"
    ]; # already a listOf string
    testAttrs = {
      expected = [
        "test1"
        "test2"
      ]; # Order should be kept
    };
  };
  coerce_attrsOf_str_to_listOf_err_coercer_input = getMatrix {
    outerTypeName = "coercedTo";
    innerTypeName = "attrsOf_str->listOf_str";
    getType = a: b: a.coercedTo (b.attrsOf b.str) builtins.attrValues (b.listOf b.str);
    value = [
      { }
      { }
    ]; # not coercible to listOf string, with the given coercer
    testAttrs = {
      expectedError = {
        type = "ThrownError";
        msg = ''A definition for option `foo."\[definition 1-entry 1\]"' is not of type `string'.*'';
      };
    };
  };
  coerce_attrsOf_str_to_listOf_err_coercer_ouput = getMatrix {
    outerTypeName = "coercedTo";
    innerTypeName = "attrsOf_str->listOf_str";
    getType = a: b: a.coercedTo (b.attrsOf b.str) builtins.attrValues (b.listOf b.str);
    value = {
      foo = {
        bar = 1;
      }; # coercer produces wrong type -> [ { bar = 1; } ]
    };
    testAttrs = {
      expectedError = {
        type = "ThrownError";
        msg = ''A definition for option `foo."\[definition 1-entry 1\]"' is not of type `string'.*'';
      };
    };
  };
  coerce_str_to_int_coercer_ouput = getMatrix {
    outerTypeName = "coercedTo";
    innerTypeName = "int->str";
    getType = a: b: a.coercedTo b.int toString a.str;
    value = [ ];
    testAttrs = {
      expectedError = {
        type = "ThrownError";
        msg = ''A definition for option `foo' is not of type `string or signed integer convertible to it.*'';
      };
    };
  };

  # Submodule
  submodule_with_ok = getMatrix {
    outerTypeName = "submoduleWith";
    innerTypeName = "mixed_types";
    getType =
      a: b:
      a.submodule (m: {
        options.attrs = m.lib.mkOption {
          type = b.attrsOf b.str;
        };
        options.list = m.lib.mkOption {
          type = b.listOf b.str;
        };
        options.either = m.lib.mkOption {
          type = b.either a.str a.int;
        };
      });
    value = {
      attrs = {
        foo = "bar";
      };
      list = [
        "foo"
        "bar"
      ];
      either = 123; # int
    };
    testAttrs = {
      expected = {
        attrs = {
          foo = "bar";
        };
        list = [
          "foo"
          "bar"
        ];
        either = 123;
      };
    };
  };
}
