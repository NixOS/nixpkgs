<!-- SPDX-FileCopyrightText: no
     SPDX-License-Identifier: CC0-1.0
-->

# Calamares Branding and Modules for NixOS

## Modules

- [nixos-generate-config](modules/nixos-generate-config) is a Python **job** module
  to gernerate a base configuration for a NixOS system. It creates a config using the `nixos-generate-config`, making minor adjustments to ensure that the base system installs correctly.

- [nixos-customize-config](modules/nixos-customize-config) is a Python **job** module
  that creates a new configuration file based on the values given by the following base calamares modules:
  - [locale](https://github.com/calamares/calamares/tree/calamares/src/modules/locale)
  - [keyboard](https://github.com/calamares/calamares/tree/calamares/src/modules/keyboard)
  - [users](https://github.com/calamares/calamares/tree/calamares/src/modules/users)
  - [partition](https://github.com/calamares/calamares/tree/calamares/src/modules/partition)
  - [packagechooser](https://github.com/calamares/calamares/tree/calamares/src/modules/packagechooser)

## Branding

- [nixos](branding/nixos) generic NixOS branding based on the [nixos homepage](https://github.com/NixOS/nixos-homepage)
