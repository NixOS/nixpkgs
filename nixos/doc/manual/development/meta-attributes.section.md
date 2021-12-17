# Meta Attributes {#sec-meta-attributes}

Like Nix packages, NixOS modules can declare meta-attributes to provide
extra information. Module meta attributes are defined in the `meta.nix`
special module.

`meta` is a top level attribute like `options` and `config`. Available
meta-attributes are `maintainers` and `doc`.

Each of the meta-attributes must be defined at most once per module
file.

```nix
{ config, lib, pkgs, ... }:
{
  options = {
    ...
  };

  config = {
    ...
  };

  meta = {
    maintainers = with lib.maintainers; [ ericsagnes ];
    doc = ./default.xml;
  };
}
```

-   `maintainers` contains a list of the module maintainers.

-   `doc` points to a valid DocBook file containing the module
    documentation. Its contents is automatically added to
    [](#ch-configuration). Changes to a module documentation have to
    be checked to not break building the NixOS manual:

    ```ShellSession
    $ nix-build nixos/release.nix -A manual.x86_64-linux
    ```
