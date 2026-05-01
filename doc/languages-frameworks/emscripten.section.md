# Emscripten {#emscripten}

[Emscripten](https://github.com/kripken/emscripten): An LLVM-to-JavaScript Compiler

If you want to work with `emcc`, `emconfigure` and `emmake` as you are used to from Ubuntu and similar distributions,

```console
nix-shell -p emscripten
```

A few things to note:

* `export EMCC_DEBUG=2` is nice for debugging
* The build artifact cache in `~/.emscripten` sometimes creates issues and needs to be removed from time to time

## Examples {#declarative-usage}

Let's see two different examples from `pkgs/top-level/emscripten-packages.nix`:

* `pkgs.zlib.override`
* `pkgs.buildEmscriptenPackage`

A special requirement of the `pkgs.buildEmscriptenPackage` is the `doCheck = true`.
This means each Emscripten package requires that a [`checkPhase`](#ssec-check-phase) is implemented.

* Use `export EMCC_DEBUG=2` from within a phase to get more detailed debug output what is going wrong.
* The cache at `~/.emscripten` requires to set `HOME=$TMPDIR` in individual phases.
  This makes compilation slower but also more deterministic.

::: {.example #usage-1-pkgs.zlib.override}

# Using `pkgs.zlib.override {}`

This example uses `zlib` from Nixpkgs, but instead of compiling **C** to **ELF** it compiles **C** to **JavaScript** since we were using `pkgs.zlib.override` and changed `stdenv` to `pkgs.emscriptenStdenv`.

A few adaptions and hacks were put in place to make it work.
One advantage is that when `pkgs.zlib` is updated, it will automatically update this package as well.


```nix
(pkgs.zlib.override { stdenv = pkgs.emscriptenStdenv; }).overrideAttrs (old: {
  buildInputs = old.buildInputs ++ [ pkg-config ];
  # we need to reset this setting!
  env = (old.env or { }) // {
    NIX_CFLAGS_COMPILE = "";
  };

  configurePhase = ''
    # FIXME: Some tests require writing at $HOME
    HOME=$TMPDIR
    runHook preConfigure

    #export EMCC_DEBUG=2
    emconfigure ./configure --prefix=$out --shared

    runHook postConfigure
  '';

  dontStrip = true;
  outputs = [ "out" ];

  buildPhase = ''
    runHook preBuild

    emmake make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    emmake make install

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    echo "================= testing zlib using node ================="

    echo "Compiling a custom test"
    set -x
    emcc -O2 -s EMULATE_FUNCTION_POINTER_CASTS=1 test/example.c -DZ_SOLO \
    libz.so.${old.version} -I . -o example.js

    echo "Using node to execute the test"
    ${pkgs.nodejs}/bin/node ./example.js

    set +x
    if [ $? -ne 0 ]; then
      echo "test failed for some reason"
      exit 1;
    else
      echo "it seems to work! very good."
    fi
    echo "================= /testing zlib using node ================="

    runHook postCheck
  '';

  postPatch = pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
    substituteInPlace configure \
      --replace-fail '/usr/bin/libtool' 'ar' \
      --replace-fail 'AR="libtool"' 'AR="ar"' \
      --replace-fail 'ARFLAGS="-o"' 'ARFLAGS="-r"'
  '';
})
```

:::{.example #usage-2-pkgs.buildemscriptenpackage}

# Using `pkgs.buildEmscriptenPackage {}`

This `xmlmirror` example features an Emscripten package that is defined completely from this context and no `pkgs.zlib.override` is used.

```nix
pkgs.buildEmscriptenPackage {
  pname = "xmlmirror";
  version = "1.2.3";

  buildInputs = [
    pkg-config
    autoconf
    automake
    libtool
    gnumake
    libxml2
    nodejs
    openjdk
    json_c
  ];

  nativeBuildInputs = [
    pkg-config
    writableTmpDirAsHomeHook
    zlib
  ];

  src = pkgs.fetchgit {
    url = "https://gitlab.com/odfplugfest/xmlmirror.git";
    rev = "4fd7e86f7c9526b8f4c1733e5c8b45175860a8fd";
    hash = "sha256-i+QgY+5PYVg5pwhzcDnkfXAznBg3e8sWH2jZtixuWsk=";
  };

  configurePhase = ''
    runHook preConfigure

    rm -f fastXmlLint.js*
    # a fix for ERROR:root:For asm.js, TOTAL_MEMORY must be a multiple of 16MB, was 234217728
    # https://gitlab.com/odfplugfest/xmlmirror/issues/8
    sed -e "s/TOTAL_MEMORY=234217728/TOTAL_MEMORY=268435456/g" -i Makefile.emEnv
    # https://github.com/kripken/emscripten/issues/6344
    # https://gitlab.com/odfplugfest/xmlmirror/issues/9
    sed -e "s/\$(JSONC_LDFLAGS) \$(ZLIB_LDFLAGS) \$(LIBXML20_LDFLAGS)/\$(JSONC_LDFLAGS) \$(LIBXML20_LDFLAGS) \$(ZLIB_LDFLAGS) /g" -i Makefile.emEnv
    # https://gitlab.com/odfplugfest/xmlmirror/issues/11
    sed -e "s/-o fastXmlLint.js/-s EXTRA_EXPORTED_RUNTIME_METHODS='[\"ccall\", \"cwrap\"]' -o fastXmlLint.js/g" -i Makefile.emEnv

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    make -f Makefile.emEnv

    runHook postBuild
  '';

  outputs = [
    "out"
    "doc"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    mkdir -p $doc/share/${name}

    cp Demo* $out/share
    cp -R codemirror-5.12 $out/share
    cp fastXmlLint.js* $out/share
    cp *.xsd $out/share
    cp *.js $out/share
    cp *.xhtml $out/share
    cp *.html $out/share
    cp *.json $out/share
    cp *.rng $out/share
    cp README.md $doc/share/${name}

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    runHook postCheck
  '';
}
```

:::

## Debugging {#declarative-debugging}

Use `nix-shell -I nixpkgs=/some/dir/nixpkgs -A emscriptenPackages.libz` and from there you can go trough the individual steps. This makes it easy to build a good `unit test` or list the files of the project.

1. `nix-shell -I nixpkgs=/some/dir/nixpkgs -A emscriptenPackages.libz`
2. `cd /tmp/`
3. `unpackPhase`
4. cd libz-1.2.3
5. `configurePhase`
6. `buildPhase`
7. ... happy hacking...
