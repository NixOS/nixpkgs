# Plotinus {#module-program-plotinus}

*Source:* {file}`modules/programs/plotinus.nix`

*Upstream documentation:* <https://github.com/p-e-w/plotinus>

Plotinus is a searchable command palette in every modern GTK application.

When in a GTK 3 application and Plotinus is enabled, you can press
`Ctrl+Shift+P` to open the command palette. The command
palette provides a searchable list of of all menu items in the application.

To enable Plotinus, add the following to your
{file}`configuration.nix`:
```nix
{ programs.plotinus.enable = true; }
```
