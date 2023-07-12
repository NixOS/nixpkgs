# Emscripten {#emscripten}

[Emscripten](https://github.com/kripken/emscripten): An LLVM-to-JavaScript Compiler

This section of the manual covers how to use `emscripten` in nixpkgs.

## Declarative usage (with `mkDerivation`) {#emscripten-declarative-usage}

This mode makes use of `nix` for dependency management and
cross-compilation of Emscripten libraries and targets by using
`mkDerivation` like most other nix packages.

Packages built this way can use the build environment from
`pkgsCross.emscripten.stdenv` and depend on other packages in
`pkgsCross.emscripten`.

For example, the `hello`, `ncurses`, `gmp` and `sqlite` packages
in `nixpkgs` build with Emscripten with no modifications.

```
$ nix-shell '<nixpkgs>' -A pkgsCross.emscripten.hello
$ node ./result/bin/hello
Hello, world!
```

### Emscripten Ports {#emscripten-ports}

In addition to nix packages that build with Emscripten, Emscripten
itself comes with a selection of libraries that are available in
`pkgsCross.emcsripten.emscriptenLibraries` (e.g. `harfbuzz` and
`icu`).

## Imperative usage (on the command line) {#emscripten-imperative-usage}

It is also possible to use `emcc`, `emconfigure`, `emmake` and other
Emscripten commands directly, as you would in Ubuntu and similar
distributions.

* The `emscripten` package is the default: it contains a pre-built
  cache of Emscripten `SYSTEM` packages (such as `libc` and
  `libembind`).

* The `emscriptenFull` package additionally contains all `PORTS`
  packages (such as `SDL2` and `sqlite`)

* The `emscriptenNoCache` package contains no pre-built cache. It
  expects that the `EM_CACHE` environment variable points to a
  writable folder. For example:

  ```
  export EM_CACHE=~/.emscripten_cache
  emcc -sUSE_SDL=2 sdl_demo.c
  ```

