# Using Newer Builtins {#sec-newer-builtins}

Newer versions of Nix sometimes create new builtin functions, which can add new functionality or be more efficient versions of existing functions in `lib`.
However, these new builtins can only be used in limited ways until they have been supported for a significant period of time by all popular implementations of Nix.
This is because of Nixpkgs' compatibility promise with both older versions of and popular alternate implementations of Nix.

The minimum featureset of Nix that Nixpkgs requires is listed in `lib/minfeatures.nix`.
In addition to the features explicitly listed, any builtin present in Nix 2.18 is able to be used.
An evaluation of Nixpkgs with a version of Nix not supporting the requirements will fail.
There is no specific process for adding new required features.

The usage of functions not within the required features list has to be done with care.
In general, packages must not use the newer builtin themselves.
Instead, `lib` can utilize these functions to improve the efficiency of existing functions, while still providing a fallback implementation in Nix for older versions.

```nix
{
  # In lib
  addOne = builtins.addOne or (x: x + 1); # implementation without new builtins
}
```

Even when a builtin may be used directly, try to use the applicable `lib` function instead when available.
Using `lib` functions makes it much easier to evolve their functionality over time, because they are not bound to Nix's strict backwards compatibility policy.

<!--## Builtins From Alternate Nix Implementations {#sec-nix-fork-builtins}

TODO: Fill in this section once the status of PRs like #498999 is determined.

Some implementations of Nix provide additional language builtins that are not present in upstream Nix.
While useful for improving performance for the users of the implementation, usage of these can be problematic because they bind Nixpkgs to the (possibly varied) implementations of the function.
These builtins...

Depending on the outcome, some ideas:
- may be used, provided their behavior matches the calling `lib` function exactly and a fallback implementation remains available indefinitely. They should never be called within packages.
- must not be used, because we can't make guarantees about their behavior.
- <omit the section entirely>

-->
