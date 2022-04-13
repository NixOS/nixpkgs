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
