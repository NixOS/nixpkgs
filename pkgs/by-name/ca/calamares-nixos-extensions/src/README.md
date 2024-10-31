<!-- SPDX-FileCopyrightText: no
     SPDX-License-Identifier: CC0-1.0
-->

# Calamares Branding and Modules for NixOS

## Modules

- [nixos](modules/nixos) is a Python **job** module
  that creates a new configuration file based on the values given by the following base calamares modules:
  - [locale](https://github.com/calamares/calamares/tree/calamares/src/modules/locale)
  - [keyboard](https://github.com/calamares/calamares/tree/calamares/src/modules/keyboard)
  - [users](https://github.com/calamares/calamares/tree/calamares/src/modules/users)
  - [partition](https://github.com/calamares/calamares/tree/calamares/src/modules/partition)
  - [packagechooser](https://github.com/calamares/calamares/tree/calamares/src/modules/packagechooser)

## Branding

- [nixos](branding/nixos) generic NixOS branding based on the [nixos homepage](https://github.com/NixOS/nixos-homepage)


## Licenses

Most code (.py, .cpp, etc) files are licensed under GPL-3.0-or-later, but see specific files for details.

Configuration files in [config](config) are licensed under [CC0-1.0](LICENSES/CC0-1.0.txt)

Images stored in [config/images](config/images) are licensed under [CC-BY-SA-4.0](LICENSES/CC-BY-SA-4.0.txt)

Images [gfx-landing-declarative.png](branding/nixos/gfx-landing-declarative.png), [gfx-landing-reliable.png](branding/nixos/gfx-landing-reliable.png), and [gfx-landing-reproducible.png](branding/nixos/gfx-landing-reproducible.png) are licensed under [CC-BY-SA-4.0](LICENSES/CC-BY-SA-4.0.txt)

Images [nix-snowflake.svg](branding/nixos/nix-snowflake.svg) and [white.png](branding/nixos/white.png) are licensed under [CC-BY-4.0](LICENSES/CC-BY-4.0.txt)

## Tests

- The `nixos` Python job module is has unit tests in [testing/](https://github.com/NixOS/calamares-nixos-extensions/tree/calamares/testing).

These tests can be executed with the command:
```sh
$ nix run .
```
