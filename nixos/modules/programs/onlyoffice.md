# ONLYOFFICE DesktopEditors {#module-programs-onlyoffice}

[ONLYOFFICE](https://www.onlyoffice.com) is an open-source office suite which is provided as a web application and also as a desktop application known as ONLYOFFICE DesktopEditors. This module is for ONLYOFFICE DesktopEditors.

## Quickstart {#module-programs-onlyoffice-quickstart}

This module installs ONLYOFFICE DesktopEditors such that fonts installed via the `fonts.packages` NixOS module are made available to ONLYOFFICE.

Here's an example of a configuration:

```nix
{ config, ... }:
{
  programs.onlyoffice.enable = true;
}
```
