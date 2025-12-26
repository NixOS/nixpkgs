# Typst {#typst}

Typst can be configured to include packages from [Typst Universe](https://typst.app/universe/) or custom packages.

## Custom Environment {#typst-custom-environment}

You can create a custom Typst environment with a selected set of packages from **Typst Universe** using the following code. It is also possible to specify a Typst package with a specific version (e.g., `cetz_0_3_0`). A package without a version number will always refer to its latest version.

```nix
typst.withPackages (
  p: with p; [
    polylux_0_4_0
    cetz_0_3_0
  ]
)
```

### Handling Outdated Package Hashes {#typst-handling-outdated-package-hashes}

Since **Typst Universe** does not provide a way to fetch a package with a specific hash, the package hashes in `nixpkgs` can sometimes be outdated. To resolve this issue, you can manually override the package source using the following approach:

```nix
typst.withPackages.override
  (old: {
    typstPackages = old.typstPackages.extend (
      _: previous: {
        polylux_0_4_0 = previous.polylux_0_4_0.overrideAttrs (oldPolylux: {
          src = oldPolylux.src.overrideAttrs { outputHash = YourUpToDatePolyluxHash; };
        });
      }
    );
  })
  (
    p: with p; [
      polylux_0_4_0
      cetz_0_3_0
    ]
  )
```

## Custom Packages {#typst-custom-packages}

`Nixpkgs` provides a helper function, `buildTypstPackage`, to build custom Typst packages that can be used within the Typst environment. However, all dependencies of the custom package must be explicitly specified in `typstDeps`.

Here's how to define a custom Typst package:

```nix
{ buildTypstPackage, typstPackages }:

buildTypstPackage (finalAttrs: {
  pname = "my-typst-package";
  version = "0.0.1";
  src = ./.;
  typstDeps = with typstPackages; [ cetz_0_3_0 ];
})
```

### Package Scope and Usage {#typst-package-scope-and-usage}

By default, every custom package is scoped under `@preview`, as shown below:

```typst
#import "@preview/my-typst-package:0.0.1": *
```

Since `@preview` is intended for packages from **Typst Universe**, it is recommended to use this approach **only for temporary or experimental modifications over existing packages** from **Typst Universe**.

On the other hand, **local packages**, packages scoped under `@local`, are **not** considered part of the Typst environment. This means that local packages must be manually linked to the Typst compiler if needed.
