# Packaging guidelines

## Basics

Each navidrome plugin is a `.zip` file named `${pname}.ndp`. Inside this zip is
two files named exactly:
- `manifest.json` which defines permissions and configuration
- `plugin.wasm` which is the output of the plugin build
