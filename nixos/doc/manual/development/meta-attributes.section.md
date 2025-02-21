# Meta Attributes {#sec-meta-attributes}

Like Nix packages, NixOS modules can declare meta-attributes to provide
extra information. Module meta attributes are defined in the `meta.nix`
special module.

`meta` is a top level attribute like `options` and `config`. Available
meta-attributes are `maintainers`, `doc`, and `buildDocsInSandbox`.

Each of the meta-attributes must be defined at most once per module
file.

```nix
{ config, lib, pkgs, ... }:
{
  options = {
    # ...
  };

  config = {
    # ...
  };

  meta = {
    maintainers = with lib.maintainers; [ ericsagnes ];
    doc = ./default.md;
    buildDocsInSandbox = true;
  };
}
```

-   `maintainers` contains a list of the module maintainers.

-   `doc` points to a valid [Nixpkgs-flavored CommonMark](
      https://nixos.org/manual/nixpkgs/unstable/#sec-contributing-markup
    ) file containing the module
    documentation. Its contents is automatically added to
    [](#ch-configuration). Changes to a module documentation have to
    be checked to not break building the NixOS manual:

    ```ShellSession
    $ nix-build nixos/release.nix -A manual.x86_64-linux
    ```

-  `buildDocsInSandbox` indicates whether the option documentation for the
   module can be built in a derivation sandbox. This option is currently only
   honored for modules shipped by nixpkgs. User modules and modules taken from
   `NIXOS_EXTRA_MODULE_PATH` are always built outside of the sandbox, as has
   been the case in previous releases.

   Building NixOS option documentation in a sandbox allows caching of the built
   documentation, which greatly decreases the amount of time needed to evaluate
   a system configuration that has NixOS documentation enabled. The sandbox also
   restricts which attributes may be referenced by documentation attributes
   (such as option descriptions) to the `options` and `lib` module arguments and
   the `pkgs.formats` attribute of the `pkgs` argument, `config` and the rest of
   `pkgs` are disallowed and will cause doc build failures when used. This
   restriction is necessary because we cannot reproduce the full nixpkgs
   instantiation with configuration and overlays from a system configuration
   inside the sandbox. The `options` argument only includes options of modules
   that are also built inside the sandbox, referencing an option of a module
   that isn't built in the sandbox is also forbidden.

   The default is `true` and should usually not be changed; set it to `false`
   only if the module requires access to `pkgs` in its documentation (e.g.
   because it loads information from a linked package to build an option type)
   or if its documentation depends on other modules that also aren't sandboxed
   (e.g. by using types defined in the other module).
