# Customising Packages {#sec-customising-packages}

Some packages in Nixpkgs have options to enable or disable optional
functionality or change other aspects of the package. For instance, the
Firefox wrapper package (which provides Firefox with a set of plugins
such as the Adobe Flash player) has an option to enable the Google Talk
plugin. It can be set in `configuration.nix` as follows:
`nixpkgs.config.firefox.enableGoogleTalkPlugin = true;`

::: {.warning}
Unfortunately, Nixpkgs currently lacks a way to query available
configuration options.
:::

Apart from high-level options, it's possible to tweak a package in
almost arbitrary ways, such as changing or disabling dependencies of a
package. For instance, the Emacs package in Nixpkgs by default has a
dependency on GTK 2. If you want to build it against GTK 3, you can
specify that as follows:

```nix
environment.systemPackages = [ (pkgs.emacs.override { gtk = pkgs.gtk3; }) ];
```

The function `override` performs the call to the Nix function that
produces Emacs, with the original arguments amended by the set of
arguments specified by you. So here the function argument `gtk` gets the
value `pkgs.gtk3`, causing Emacs to depend on GTK 3. (The parentheses
are necessary because in Nix, function application binds more weakly
than list construction, so without them,
[](#opt-environment.systemPackages)
would be a list with two elements.)

Even greater customisation is possible using the function
`overrideAttrs`. While the `override` mechanism above overrides the
arguments of a package function, `overrideAttrs` allows changing the
*attributes* passed to `mkDerivation`. This permits changing any aspect
of the package, such as the source code. For instance, if you want to
override the source code of Emacs, you can say:

```nix
environment.systemPackages = [
  (pkgs.emacs.overrideAttrs (oldAttrs: {
    name = "emacs-25.0-pre";
    src = /path/to/my/emacs/tree;
  }))
];
```

Here, `overrideAttrs` takes the Nix derivation specified by `pkgs.emacs`
and produces a new derivation in which the original's `name` and `src`
attribute have been replaced by the given values by re-calling
`stdenv.mkDerivation`. The original attributes are accessible via the
function argument, which is conventionally named `oldAttrs`.

The overrides shown above are not global. They do not affect the
original package; other packages in Nixpkgs continue to depend on the
original rather than the customised package. This means that if another
package in your system depends on the original package, you end up with
two instances of the package. If you want to have everything depend on
your customised instance, you can apply a *global* override as follows:

```nix
nixpkgs.config.packageOverrides = pkgs:
  { emacs = pkgs.emacs.override { gtk = pkgs.gtk3; };
  };
```

The effect of this definition is essentially equivalent to modifying the
`emacs` attribute in the Nixpkgs source tree. Any package in Nixpkgs
that depends on `emacs` will be passed your customised instance.
(However, the value `pkgs.emacs` in `nixpkgs.config.packageOverrides`
refers to the original rather than overridden instance, to prevent an
infinite recursion.)
