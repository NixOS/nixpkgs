# Packaging guidelines

## Basics

Each navidrome plugin is a `.zip` file named `${pname}.ndp`. Inside this zip is
two files named exactly:
- `manifest.json` which defines permissions and configuration
- `plugin.wasm` which is the output of the plugin build

## Builders

The builders all currently have their platforms set to `wasi` and are
accessed/built through `pkgs.pkgsCross.wasi32.navidromePlugins.<name>`. This is
the most efficient way to cross-compile the plugins under wasip1-wasm.

### `bundleName`

This property allows you to specify the name of the ndp file that is symlinked
within Navidrome. Navidrome keys off of the file name for plugins and the output
name may differ from the documentation, so we allow setting `bundleName` which
makes the documentation of a particular plugin easier to follow.

### `buildNavidromeGoPlugin`

This builder uses the standard `buildGoModule` under the hood (from within the
wasi arch's `callPackage`).
