# Paisa {#module-services-paisa}

*Source:* {file}`modules/services/misc/paisa.nix`

*Upstream documentation:* <https://paisa.fyi/>

[Paisa](https://github.com/ananthakumaran/paisa) is a personal finance manager
built on top of the ledger plain-text-accounting tool.

## Usage {#module-services-paisa-usage}

Paisa needs to have one of the following cli tools availabe in the PATH at
runtime:

- ledger
- hledger
- beancount

All of these are available from nixpkgs. Currently, it is not possible to
configure this in the module, but you can e.g. use systemd to give the unit
access to the command at runtime.

```nix
{ systemd.services.paisa.path = [ pkgs.hledger ]; }
```

::: {.note}
Paisa needs to be configured to use the correct cli tool. This is possible in
the web interface (make sure to enable [](#opt-services.paisa.mutableSettings)
if you want to persist these settings between service restarts), or in
[](#opt-services.paisa.settings).
:::
