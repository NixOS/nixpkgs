# Options Types {#sec-option-types}

Option types are a way to put constraints on the values a module option
can take. Types are also responsible of how values are merged in case of
multiple value definitions.

## Basic types {#sec-option-types-basic}

Basic types are the simplest available types in the module system. Basic
types include multiple string types that mainly differ in how definition
merging is handled.

`types.bool`

:   A boolean, its values can be `true` or `false`.

`types.path`

:   A filesystem path is anything that starts with a slash when
    coerced to a string. Even if derivations can be considered as
    paths, the more specific `types.package` should be preferred.

`types.package`

:   A top-level store path. This can be an attribute set pointing
    to a store path, like a derivation or a flake input.

`types.enum` *`l`*

:   One element of the list *`l`*, e.g. `types.enum [ "left" "right" ]`.
    Multiple definitions cannot be merged.

`types.anything`

:   A type that accepts any value and recursively merges attribute sets
    together. This type is recommended when the option type is unknown.

    ::: {#ex-types-anything .example}
    ::: {.title}
    **Example: `types.anything` Example**
    :::
    Two definitions of this type like

    ```nix
    {
      str = lib.mkDefault "foo";
      pkg.hello = pkgs.hello;
      fun.fun = x: x + 1;
    }
    ```

    ```nix
    {
      str = lib.mkIf true "bar";
      pkg.gcc = pkgs.gcc;
      fun.fun = lib.mkForce (x: x + 2);
    }
    ```

    will get merged to

    ```nix
    {
      str = "bar";
      pkg.gcc = pkgs.gcc;
      pkg.hello = pkgs.hello;
      fun.fun = x: x + 2;
    }
    ```
    :::

`types.raw`

:   A type which doesn't do any checking, merging or nested evaluation. It
    accepts a single arbitrary value that is not recursed into, making it
    useful for values coming from outside the module system, such as package
    sets or arbitrary data. Options of this type are still evaluated according
    to priorities and conditionals, so `mkForce`, `mkIf` and co. still work on
    the option value itself, but not for any value nested within it. This type
    should only be used when checking, merging and nested evaluation are not
    desirable.

`types.optionType`

:   The type of an option's type. Its merging operation ensures that nested
    options have the correct file location annotated, and that if possible,
    multiple option definitions are correctly merged together. The main use
    case is as the type of the `_module.freeformType` option.

`types.attrs`

:   A free-form attribute set.

    ::: {.warning}
    This type will be deprecated in the future because it doesn't
    recurse into attribute sets, silently drops earlier attribute
    definitions, and doesn't discharge `lib.mkDefault`, `lib.mkIf`
    and co. For allowing arbitrary attribute sets, prefer
    `types.attrsOf types.anything` instead which doesn't have these
    problems.
    :::

### Numeric types {#sec-option-types-numeric}

`types.int`

:   A signed integer.

`types.ints.{s8, s16, s32}`

:   Signed integers with a fixed length (8, 16 or 32 bits). They go from
    −2^n/2 to
    2^n/2−1 respectively (e.g. `−128` to
    `127` for 8 bits).

`types.ints.unsigned`

:   An unsigned integer (that is >= 0).

`types.ints.{u8, u16, u32}`

:   Unsigned integers with a fixed length (8, 16 or 32 bits). They go
    from 0 to 2^n−1 respectively (e.g. `0`
    to `255` for 8 bits).

`types.ints.between` *`lowest highest`*

:   An integer between *`lowest`* and *`highest`* (both inclusive).

`types.ints.positive`

:   A positive integer (that is > 0).

`types.port`

:   A port number. This type is an alias to
    `types.ints.u16`.

`types.float`

:   A floating point number.

    ::: {.warning}
    Converting a floating point number to a string with `toString` or `toJSON`
    may result in [precision loss](https://github.com/NixOS/nix/issues/5733).
    :::

`types.number`

:   Either a signed integer or a floating point number. No implicit conversion
    is done between the two types, and multiple equal definitions will only be
    merged if they have the same type.

`types.numbers.between` *`lowest highest`*

:   An integer or floating point number between *`lowest`* and *`highest`* (both inclusive).

`types.numbers.nonnegative`

:   A nonnegative integer or floating point number (that is >= 0).

`types.numbers.positive`

:   A positive integer or floating point number (that is > 0).

### String types {#sec-option-types-string}

`types.str`

:   A string. Multiple definitions cannot be merged.

`types.separatedString` *`sep`*

:   A string. Multiple definitions are concatenated with *`sep`*, e.g.
    `types.separatedString "|"`.

`types.lines`

:   A string. Multiple definitions are concatenated with a new line
    `"\n"`.

`types.commas`

:   A string. Multiple definitions are concatenated with a comma `","`.

`types.envVar`

:   A string. Multiple definitions are concatenated with a colon `":"`.

`types.strMatching`

:   A string matching a specific regular expression. Multiple
    definitions cannot be merged. The regular expression is processed
    using `builtins.match`.

## Submodule types {#sec-option-types-submodule}

Submodules are detailed in [Submodule](#section-option-types-submodule).

`types.submodule` *`o`*

:   A set of sub options *`o`*. *`o`* can be an attribute set, a function
    returning an attribute set, or a path to a file containing such a
    value. Submodules are used in composed types to create modular
    options. This is equivalent to
    `types.submoduleWith { modules = toList o; shorthandOnlyDefinesConfig = true; }`.

`types.submoduleWith` { *`modules`*, *`specialArgs`* ? {}, *`shorthandOnlyDefinesConfig`* ? false }

:   Like `types.submodule`, but more flexible and with better defaults.
    It has parameters

    -   *`modules`* A list of modules to use by default for this
        submodule type. This gets combined with all option definitions
        to build the final list of modules that will be included.

        ::: {.note}
        Only options defined with this argument are included in rendered
        documentation.
        :::

    -   *`specialArgs`* An attribute set of extra arguments to be passed
        to the module functions. The option `_module.args` should be
        used instead for most arguments since it allows overriding.
        *`specialArgs`* should only be used for arguments that can't go
        through the module fixed-point, because of infinite recursion or
        other problems. An example is overriding the `lib` argument,
        because `lib` itself is used to define `_module.args`, which
        makes using `_module.args` to define it impossible.

    -   *`shorthandOnlyDefinesConfig`* Whether definitions of this type
        should default to the `config` section of a module (see
        [Example: Structure of NixOS Modules](#ex-module-syntax))
        if it is an attribute set. Enabling this only has a benefit
        when the submodule defines an option named `config` or `options`.
        In such a case it would allow the option to be set with
        `the-submodule.config = "value"` instead of requiring
        `the-submodule.config.config = "value"`. This is because
        only when modules *don't* set the `config` or `options`
        keys, all keys are interpreted as option definitions in the
        `config` section. Enabling this option implicitly puts all
        attributes in the `config` section.

        With this option enabled, defining a non-`config` section
        requires using a function:
        `the-submodule = { ... }: { options = { ... }; }`.

`types.deferredModule`

:   Whereas `submodule` represents an option tree, `deferredModule` represents
    a module value, such as a module file or a configuration.

    It can be set multiple times.

    Module authors can use its value in `imports`, in `submoduleWith`'s `modules`
    or in `evalModules`' `modules` parameter, among other places.

    Note that `imports` must be evaluated before the module fixpoint. Because
    of this, deferred modules can only be imported into "other" fixpoints, such
    as submodules.

    One use case for this type is the type of a "default" module that allow the
    user to affect all submodules in an `attrsOf submodule` at once. This is
    more convenient and discoverable than expecting the module user to
    type-merge with the `attrsOf submodule` option.

## Composed types {#sec-option-types-composed}

Composed types are types that take a type as parameter. `listOf
   int` and `either int str` are examples of composed types.

`types.listOf` *`t`*

:   A list of *`t`* type, e.g. `types.listOf
          int`. Multiple definitions are merged with list concatenation.

`types.attrsOf` *`t`*

:   An attribute set of where all the values are of *`t`* type. Multiple
    definitions result in the joined attribute set.

    ::: {.note}
    This type is *strict* in its values, which in turn means attributes
    cannot depend on other attributes. See `
           types.lazyAttrsOf` for a lazy version.
    :::

`types.lazyAttrsOf` *`t`*

:   An attribute set of where all the values are of *`t`* type. Multiple
    definitions result in the joined attribute set. This is the lazy
    version of `types.attrsOf
          `, allowing attributes to depend on each other.

    ::: {.warning}
    This version does not fully support conditional definitions! With an
    option `foo` of this type and a definition
    `foo.attr = lib.mkIf false 10`, evaluating `foo ? attr` will return
    `true` even though it should be false. Accessing the value will then
    throw an error. For types *`t`* that have an `emptyValue` defined,
    that value will be returned instead of throwing an error. So if the
    type of `foo.attr` was `lazyAttrsOf (nullOr int)`, `null` would be
    returned instead for the same `mkIf false` definition.
    :::

`types.nullOr` *`t`*

:   `null` or type *`t`*. Multiple definitions are merged according to
    type *`t`*.

`types.uniq` *`t`*

:   Ensures that type *`t`* cannot be merged. It is used to ensure option
    definitions are declared only once.

`types.unique` `{ message = m }` *`t`*

:   Ensures that type *`t`* cannot be merged. Prints the message *`m`*, after
    the line `The option <option path> is defined multiple times.` and before
    a list of definition locations.

`types.either` *`t1 t2`*

:   Type *`t1`* or type *`t2`*, e.g. `with types; either int str`.
    Multiple definitions cannot be merged.

`types.oneOf` \[ *`t1 t2`* ... \]

:   Type *`t1`* or type *`t2`* and so forth, e.g.
    `with types; oneOf [ int str bool ]`. Multiple definitions cannot be
    merged.

`types.coercedTo` *`from f to`*

:   Type *`to`* or type *`from`* which will be coerced to type *`to`* using
    function *`f`* which takes an argument of type *`from`* and return a
    value of type *`to`*. Can be used to preserve backwards compatibility
    of an option if its type was changed.

## Submodule {#section-option-types-submodule}

`submodule` is a very powerful type that defines a set of sub-options
that are handled like a separate module.

It takes a parameter *`o`*, that should be a set, or a function returning
a set with an `options` key defining the sub-options. Submodule option
definitions are type-checked accordingly to the `options` declarations.
Of course, you can nest submodule option definitions for even higher
modularity.

The option set can be defined directly
([Example: Directly defined submodule](#ex-submodule-direct)) or as reference
([Example: Submodule defined as a reference](#ex-submodule-reference)).

Note that even if your submodule’s options all have a default value,
you will still need to provide a default value (e.g. an empty attribute set)
if you want to allow users to leave it undefined.

::: {#ex-submodule-direct .example}
::: {.title}
**Example: Directly defined submodule**
:::
```nix
options.mod = mkOption {
  description = "submodule example";
  type = with types; submodule {
    options = {
      foo = mkOption {
        type = int;
      };
      bar = mkOption {
        type = str;
      };
    };
  };
};
```
:::

::: {#ex-submodule-reference .example}
::: {.title}
**Example: Submodule defined as a reference**
:::
```nix
let
  modOptions = {
    options = {
      foo = mkOption {
        type = int;
      };
      bar = mkOption {
        type = int;
      };
    };
  };
in
options.mod = mkOption {
  description = "submodule example";
  type = with types; submodule modOptions;
};
```
:::

The `submodule` type is especially interesting when used with composed
types like `attrsOf` or `listOf`. When composed with `listOf`
([Example: Declaration of a list of submodules](#ex-submodule-listof-declaration)), `submodule` allows
multiple definitions of the submodule option set
([Example: Definition of a list of submodules](#ex-submodule-listof-definition)).

::: {#ex-submodule-listof-declaration .example}
::: {.title}
**Example: Declaration of a list of submodules**
:::
```nix
options.mod = mkOption {
  description = "submodule example";
  type = with types; listOf (submodule {
    options = {
      foo = mkOption {
        type = int;
      };
      bar = mkOption {
        type = str;
      };
    };
  });
};
```
:::

::: {#ex-submodule-listof-definition .example}
::: {.title}
**Example: Definition of a list of submodules**
:::
```nix
config.mod = [
  { foo = 1; bar = "one"; }
  { foo = 2; bar = "two"; }
];
```
:::

When composed with `attrsOf`
([Example: Declaration of attribute sets of submodules](#ex-submodule-attrsof-declaration)), `submodule` allows
multiple named definitions of the submodule option set
([Example: Definition of attribute sets of submodules](#ex-submodule-attrsof-definition)).

::: {#ex-submodule-attrsof-declaration .example}
::: {.title}
**Example: Declaration of attribute sets of submodules**
:::
```nix
options.mod = mkOption {
  description = "submodule example";
  type = with types; attrsOf (submodule {
    options = {
      foo = mkOption {
        type = int;
      };
      bar = mkOption {
        type = str;
      };
    };
  });
};
```
:::

::: {#ex-submodule-attrsof-definition .example}
::: {.title}
**Example: Definition of attribute sets of submodules**
:::
```nix
config.mod.one = { foo = 1; bar = "one"; };
config.mod.two = { foo = 2; bar = "two"; };
```
:::

## Extending types {#sec-option-types-extending}

Types are mainly characterized by their `check` and `merge` functions.

`check`

:   The function to type check the value. Takes a value as parameter and
    return a boolean. It is possible to extend a type check with the
    `addCheck` function ([Example: Adding a type check](#ex-extending-type-check-1)),
    or to fully override the check function
    ([Example: Overriding a type check](#ex-extending-type-check-2)).

    ::: {#ex-extending-type-check-1 .example}
    ::: {.title}
    **Example: Adding a type check**
    :::
    ```nix
    byte = mkOption {
      description = "An integer between 0 and 255.";
      type = types.addCheck types.int (x: x >= 0 && x <= 255);
    };
    ```
    :::

    ::: {#ex-extending-type-check-2 .example}
    ::: {.title}
    **Example: Overriding a type check**
    :::
    ```nix
    nixThings = mkOption {
      description = "words that start with 'nix'";
      type = types.str // {
        check = (x: lib.hasPrefix "nix" x)
      };
    };
    ```
    :::

`merge`

:   Function to merge the options values when multiple values are set.
    The function takes two parameters, `loc` the option path as a list
    of strings, and `defs` the list of defined values as a list. It is
    possible to override a type merge function for custom needs.

## Custom types {#sec-option-types-custom}

Custom types can be created with the `mkOptionType` function. As type
creation includes some more complex topics such as submodule handling,
it is recommended to get familiar with `types.nix` code before creating
a new type.

The only required parameter is `name`.

`name`

:   A string representation of the type function name.

`definition`

:   Description of the type used in documentation. Give information of
    the type and any of its arguments.

`check`

:   A function to type check the definition value. Takes the definition
    value as a parameter and returns a boolean indicating the type check
    result, `true` for success and `false` for failure.

`merge`

:   A function to merge multiple definitions values. Takes two
    parameters:

    *`loc`*

    :   The option path as a list of strings, e.g. `["boot" "loader
                 "grub" "enable"]`.

    *`defs`*

    :   The list of sets of defined `value` and `file` where the value
        was defined, e.g. `[ {
                 file = "/foo.nix"; value = 1; } { file = "/bar.nix"; value = 2 }
                 ]`. The `merge` function should return the merged value
        or throw an error in case the values are impossible or not meant
        to be merged.

`getSubOptions`

:   For composed types that can take a submodule as type parameter, this
    function generate sub-options documentation. It takes the current
    option prefix as a list and return the set of sub-options. Usually
    defined in a recursive manner by adding a term to the prefix, e.g.
    `prefix:
          elemType.getSubOptions (prefix ++
          ["prefix"])` where *`"prefix"`* is the newly added prefix.

`getSubModules`

:   For composed types that can take a submodule as type parameter, this
    function should return the type parameters submodules. If the type
    parameter is called `elemType`, the function should just recursively
    look into submodules by returning `elemType.getSubModules;`.

`substSubModules`

:   For composed types that can take a submodule as type parameter, this
    function can be used to substitute the parameter of a submodule
    type. It takes a module as parameter and return the type with the
    submodule options substituted. It is usually defined as a type
    function call with a recursive call to `substSubModules`, e.g for a
    type `composedType` that take an `elemtype` type parameter, this
    function should be defined as `m:
          composedType (elemType.substSubModules m)`.

`typeMerge`

:   A function to merge multiple type declarations. Takes the type to
    merge `functor` as parameter. A `null` return value means that type
    cannot be merged.

    *`f`*

    :   The type to merge `functor`.

    Note: There is a generic `defaultTypeMerge` that work with most of
    value and composed types.

`functor`

:   An attribute set representing the type. It is used for type
    operations and has the following keys:

    `type`

    :   The type function.

    `wrapped`

    :   Holds the type parameter for composed types.

    `payload`

    :   Holds the value parameter for value types. The types that have a
        `payload` are the `enum`, `separatedString` and `submodule`
        types.

    `binOp`

    :   A binary operation that can merge the payloads of two same
        types. Defined as a function that take two payloads as
        parameters and return the payloads merged.
