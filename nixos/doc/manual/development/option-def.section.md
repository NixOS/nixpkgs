# Option Definitions {#sec-option-definitions}

Option definitions are generally straight-forward bindings of values to
option names, like

```nix
config = {
  services.httpd.enable = true;
};
```

However, sometimes you need to wrap an option definition or set of
option definitions in a *property* to achieve certain effects:

## Delaying Conditionals {#sec-option-definitions-delaying-conditionals .unnumbered}

If a set of option definitions is conditional on the value of another
option, you may need to use `mkIf`. Consider, for instance:

```nix
config = if config.services.httpd.enable then {
  environment.systemPackages = [ ... ];
  ...
} else {};
```

This definition will cause Nix to fail with an "infinite recursion"
error. Why? Because the value of `config.services.httpd.enable` depends
on the value being constructed here. After all, you could also write the
clearly circular and contradictory:

```nix
config = if config.services.httpd.enable then {
  services.httpd.enable = false;
} else {
  services.httpd.enable = true;
};
```

The solution is to write:

```nix
config = mkIf config.services.httpd.enable {
  environment.systemPackages = [ ... ];
  ...
};
```

The special function `mkIf` causes the evaluation of the conditional to
be "pushed down" into the individual definitions, as if you had written:

```nix
config = {
  environment.systemPackages = if config.services.httpd.enable then [ ... ] else [];
  ...
};
```

## Setting Priorities {#sec-option-definitions-setting-priorities .unnumbered}

A module can override the definitions of an option in other modules by
setting a *priority*. All option definitions that do not have the lowest
priority value are discarded. By default, option definitions have
priority 1000. You can specify an explicit priority by using
`mkOverride`, e.g.

```nix
services.openssh.enable = mkOverride 10 false;
```

This definition causes all other definitions with priorities above 10 to
be discarded. The function `mkForce` is equal to `mkOverride 50`.

## Merging Configurations {#sec-option-definitions-merging .unnumbered}

In conjunction with `mkIf`, it is sometimes useful for a module to
return multiple sets of option definitions, to be merged together as if
they were declared in separate modules. This can be done using
`mkMerge`:

```nix
config = mkMerge
  [ # Unconditional stuff.
    { environment.systemPackages = [ ... ];
    }
    # Conditional stuff.
    (mkIf config.services.bla.enable {
      environment.systemPackages = [ ... ];
    })
  ];
```
