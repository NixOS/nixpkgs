# Fish {#sec-fish}

Fish is a "smart and user-friendly command line shell" with support for plugins.


## Vendor Fish scripts {#sec-fish-vendor}

Any package may ship its own Fish completions, configuration snippets, and
functions. Those should be installed to
`$out/share/fish/vendor_{completions,conf,functions}.d` respectively.

When the `programs.fish.enable` and
`programs.fish.vendor.{completions,config,functions}.enable` options from the
NixOS Fish module are set to true, those paths are symlinked in the current
system environment and are automatically loaded by Fish.


## Packaging Fish plugins {#sec-fish-plugins-pkg}

While packages providing standalone executables belong to the top level,
packages which have the sole purpose of extending Fish belong to the
`fishPlugins` scope and should be registered in
`pkgs/shells/fish/plugins/default.nix`.

The `buildFishPlugin` utility function can be used to automatically copy Fish
scripts from `$src/{completions,conf,conf.d,functions}` to the standard vendor
installation paths. It also sets up the test environment so that the optional
`checkPhase` is executed in a Fish shell with other already packaged plugins
and package-local Fish functions specified in `checkPlugins` and
`checkFunctionDirs` respectively.

See `pkgs/shells/fish/plugins/pure.nix` for an example of Fish plugin package
using `buildFishPlugin` and running unit tests with the `fishtape` test runner.


## Fish wrapper {#sec-fish-wrapper}

The `wrapFish` package is a wrapper around Fish which can be used to create
Fish shells initialized with some plugins as well as completions, configuration
snippets and functions sourced from the given paths. This provides a convenient
way to test Fish plugins and scripts without having to alter the environment.

```nix
wrapFish {
  pluginPkgs = with fishPlugins; [
    pure
    foreign-env
  ];
  completionDirs = [ ];
  functionDirs = [ ];
  confDirs = [ "/path/to/some/fish/init/dir/" ];
}
```
