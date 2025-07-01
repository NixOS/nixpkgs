{ lib }:

# This defines an algebra to express platform constraints using AND, OR and NOT
# which behave like boolean operators but for platform properties.
#
# Examples:
#
# with lib.meta.platform.constraints;
# OR [
#   isLinux
#   isDarwin
# ]
#
# with lib.meta.platform.constraints;
# AND [
#   (OR [
#     isLinux
#     isDarwin
#   ])
#   (OR [
#     isx86
#     isAarch
#   ])
#   (NOT isMusl)
# ]

let
  inherit (lib.meta) platformMatch;
  inherit (lib) head;

  operations = {
    OR = lib.any lib.id;
    AND = lib.all lib.id;
    NOT = x: !(head x);
  };

in

rec {
  /**
    A DSL to declare which platform properties constrain a package's function.
    Many packages only work on some platforms, CPUs or other properties of a platform.
    This DSL is how you declare those facts.
    These constraints can be any property of a platform expressed as a platform pattern.
    See `lib.meta.platformMatch` for more information about platform properties and platform matching.

    Constraints can be combined with arbitrary complexity using the boolean operators `AND`, `OR` and `NOT`.

    For convenience, `lib.systems.inspect.patterns` and `lib.systems.inspect.platformPatterns` are also available in this set.

    `evalConstraints` evaluates a platform constraints expression into a single boolean value for a given platform.

    # Examples
    :::{.example}
    ## `lib.meta.platform.constraints` simple usage example

    This will only match Linux platforms:

    ```
    lib.meta.platform.constraints.isLinux
    ```

    :::

    :::{.example}
    ## `lib.meta.platform.constraints` complex usage example

    This is (made up, nonsensical) example of a more complex expression:

    ```nix
    with lib.meta.platform.constraints;
    AND [
      NONE
      (OR [
        isLinux
        isDarwin
        (AND [
          isLittleEndian
          is64bit
          (OR [ isMusl ])
        ])
        NONE
        {
          cpu = { family = "myWeirdArch"; };
        };
      ])
    ];
    ```

    :::
  */
  constraints =
    rec {
      OR = value: {
        __operation = "OR";
        inherit value;
      };
      AND = value: {
        __operation = "AND";
        inherit value;
      };
      NOT = value: {
        __operation = "NOT";
        value = [ value ]; # Also make this a list for simplicity
      };

      ANY = { };
      NONE = NOT ANY;
    }
    # Put patterns in this set for convenient use
    // lib.systems.inspect.patterns
    # Platform patterns too. We can just do this because platforms (i.e. `hostPlatform`) have all of these
    # mashed together too.
    // lib.systems.inspect.platformPatterns;

  /**
    Evaluates a platform constraints expression into a boolean value for a given platform similar to how `lib.meta.platformMatch` performs checks for a single constraint.
    Because this uses `lib.meta.platformMatch` internally, it supports the same set of platform properties.
    This is intended to be used with `lib.platform.constraints` and supports its boolean operators.

    # Inputs

    `platform`
    : 1\. The platform to run the constraint checks against

    `constraints`
    : 2\. A platform constraints expression to check the platform with

    # Examples
    :::{.example}
    ## `lib.platform.evaluateConstraints` usage example

    This evaluates to true because `aarch64-linux` matches the `isLinux` constraint `OR`'d with `isDarwin` (which does not match):

    ```
    lib.platform.evalConstraints "aarch64-linux" (with lib.platform.constraints; OR [ isLinux isDarwin ])
    ```

    :::

  */
  evalConstraints =
    platform: constraint:
    if constraint ? __operation then
      operations.${constraint.__operation} (map (evalConstraints platform) constraint.value)
    else
      platformMatch platform constraint;

  prettyPrinters =
    let
      getStandardConstraintNames =
        v:
        lib.pipe constraints [
          (lib.filterAttrs (_: it: it == v))
          lib.attrNames
        ];
    in
    {
      operation = {
        check = v: lib.isAttrs v && v ? __operation;
        print =
          {
            indent,
            v,
            go,
            ...
          }:
          "${v.__operation} ${go indent v.value}";
      };
      constraint = {
        check =
          v:
          let
            standardConstraintNames = getStandardConstraintNames v;
          in
          lib.length standardConstraintNames >= 1;
        print =
          {
            v,
            ...
          }:
          let
            standardConstraintNames = getStandardConstraintNames v;
          in
          lib.head standardConstraintNames;
      };
    };
}
