# Option Definitions {#sec-option-definitions}

Option definitions are generally straight-forward bindings of values to
option names, like

```nix
{
  config = {
    services.httpd.enable = true;
  };
}
```

However, sometimes you need to wrap an option definition or set of
option definitions in a *property* to achieve certain effects:

## Delaying Conditionals {#sec-option-definitions-delaying-conditionals}

If a set of option definitions is conditional on the value of another
option, you may need to use `mkIf`. Consider, for instance:

```nix
{
  config =
    if config.services.httpd.enable then
      {
        environment.systemPackages = [
          # ...
        ];
        # ...
      }
    else
      { };
}
```

This definition will cause Nix to fail with an "infinite recursion"
error. Why? Because the value of `config.services.httpd.enable` depends
on the value being constructed here. After all, you could also write the
clearly circular and contradictory:

```nix
{
  config =
    if config.services.httpd.enable then
      {
        services.httpd.enable = false;
      }
    else
      {
        services.httpd.enable = true;
      };
}
```

The solution is to write:

```nix
{
  config = mkIf config.services.httpd.enable {
    environment.systemPackages = [
      # ...
    ];
    # ...
  };
}
```

The special function `mkIf` causes the evaluation of the conditional to
be "pushed down" into the individual definitions, as if you had written:

```nix
{
  config = {
    environment.systemPackages =
      if config.services.httpd.enable then
        [
          # ...
        ]
      else
        [ ];
    # ...
  };
}
```

## Setting Priorities {#sec-option-definitions-setting-priorities}

A module can override the definitions of an option in other modules by
setting an *override priority*. All option definitions that do not have the lowest
priority value are discarded. By default, option definitions have
priority 100 and option defaults have priority 1500.
You can specify an explicit priority by using `mkOverride`, e.g.

```nix
{ services.openssh.enable = mkOverride 10 false; }
```

This definition causes all other definitions with priorities above 10 to
be discarded. The function `mkForce` is equal to `mkOverride 50`, and
`mkDefault` is equal to `mkOverride 1000`.

## Ordering Definitions {#sec-option-definitions-ordering}

It is also possible to influence the order in which the definitions for an option are
merged by setting an *order priority* with `mkOrder`. The default order priority is 1000.
The functions `mkBefore` and `mkAfter` are equal to `mkOrder 500` and `mkOrder 1500`, respectively.
As an example,

```nix
{ hardware.firmware = mkBefore [ myFirmware ]; }
```

This definition ensures that `myFirmware` comes before other unordered
definitions in the final list value of `hardware.firmware`.

Note that this is different from [override priorities](#sec-option-definitions-setting-priorities):
setting an order does not affect whether the definition is included or not.

## Merging Configurations {#sec-option-definitions-merging}

In conjunction with `mkIf`, it is sometimes useful for a module to
return multiple sets of option definitions, to be merged together as if
they were declared in separate modules. This can be done using
`mkMerge`:

```nix
{
  config = mkMerge [
    # Unconditional stuff.
    {
      environment.systemPackages = [
        # ...
      ];
    }
    # Conditional stuff.
    (mkIf config.services.bla.enable {
      environment.systemPackages = [
        # ...
      ];
    })
  ];
}
```

## Free-floating definitions {#sec-option-definitions-definitions}

:::{.note}
The module system internally transforms module syntax into definitions. This always happens internally.
:::

It is possible to create first class definitions which are not transformed _again_ into definitions by the module system.

Usually the file location of a definition is implicit and equal to the file it came from.
However, when manipulating definitions, it may be useful for them to be completely self-contained (or "free-floating").

A free-floating definition is created with `mkDefinition { file = ...; value = ...; }`.

Preserving the file location creates better error messages, for example when copying definitions from one option to another.

Other properties like `mkOverride` `mkMerge` `mkAfter` can be used in the `value` attribute but not on the entire definition.

This is what would work

```nix
mkDefinition {
  value = mkForce 42;
  file = "somefile.nix";
}
```

While this would NOT work.

```nix
mkForce (mkDefinition {
  value = 42;
  file = "somefile.nix";
})
```

The following shows an example configuration that yields an error with the custom position information:

```nix
{
  _file = "file.nix";
  options.foo = mkOption { default = 13; };
  config.foo = lib.mkDefinition {
    file = "custom place";
    # mkOptionDefault creates a conflict with the option foo's `default = 1` on purpose
    # So we see the error message below contains the conflicting values and different positions
    value = lib.mkOptionDefault 42;
  };
}
```

evaluating the module yields the following error:

```
error: Cannot merge definitions of `foo'. Definition values:
- In `file.nix': 13
- In `custom place': 42
```

To set the file location for all definitions in a module, you may add the `_file` module syntax attribute, which has a similar effect to using `mkDefinition` on all definitions in the module, without the hassle.
