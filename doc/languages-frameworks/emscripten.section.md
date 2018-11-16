# User's Guide to Emscripten in Nixpkgs

[Emscripten](https://github.com/kripken/emscripten): An LLVM-to-JavaScript Compiler

This section of the manual covers how to use `emscripten` in nixpkgs.

Minimal requirements:

* nix
* nixpkgs

Modes of use of `emscripten`:

* **Imperative usage** (on the command line):

   If you want to work with `emcc`, `emconfigure` and `emmake` as you are used to from Ubuntu and similar distributions you can use these commands:

    * `nix-env -i emscripten`
    * `nix-shell -p emscripten`

* **Declarative usage**:

    This mode is far more power full since this makes use of `nix` for dependency management of emscripten libraries and targets by using the `mkDerivation` which is implemented by `pkgs.emscriptenStdenv` and `pkgs.buildEmscriptenPackage`. The source for the packages is in `pkgs/top-level/emscripten-packages.nix` and the abstraction behind it in `pkgs/development/em-modules/generic/default.nix`.
    * build and install all packages: 
        * `nix-env -iA emscriptenPackages` 
          
    * dev-shell for zlib implementation hacking: 
        * `nix-shell -A emscriptenPackages.zlib` 


## Imperative usage

A few things to note:

* `export EMCC_DEBUG=2` is nice for debugging
* `~/.emscripten`, the build artifact cache sometimes creates issues and needs to be removed from time to time


## Declarative usage

Let's see two different examples from `pkgs/top-level/emscripten-packages.nix`:

* `pkgs.zlib.override`
* `pkgs.buildEmscriptenPackage`

Both are interesting concepts.

A special requirement of the `pkgs.buildEmscriptenPackage` is the `doCheck = true` is a default meaning that each emscriptenPackage requires a `checkPhase` implemented.

* Use `export EMCC_DEBUG=2` from within a emscriptenPackage's `phase` to get more detailed debug output what is going wrong.
* ~/.emscripten cache is requiring us to set `HOME=$TMPDIR` in individual phases. This makes compilation slower but also makes it more deterministic.

### Usage 1: pkgs.zlib.override

This example uses `zlib` from nixpkgs but instead of compiling **C** to **ELF** it compiles **C** to **JS** since we were using `pkgs.zlib.override` and changed stdenv to `pkgs.emscriptenStdenv`. A few adaptions and hacks were set in place to make it working. One advantage is that when `pkgs.zlib` is updated, it will automatically update this package as well. However, this can also be the downside...

See the `zlib` example:

    zlib = (pkgs.zlib.override {
      stdenv = pkgs.emscriptenStdenv;
    }).overrideDerivation
    (old: rec {
      buildInputs = old.buildInputs ++ [ pkgconfig ];
      # we need to reset this setting!
      NIX_CFLAGS_COMPILE="";
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
        emmake make
      '';
      installPhase = ''
        emmake make install
      '';
      checkPhase = ''
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
      '';

      postPatch = pkgs.stdenv.lib.optionalString pkgs.stdenv.isDarwin ''
        substituteInPlace configure \
          --replace '/usr/bin/libtool' 'ar' \
          --replace 'AR="libtool"' 'AR="ar"' \
          --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
      '';
    });

### Usage 2: pkgs.buildEmscriptenPackage

This `xmlmirror` example features a emscriptenPackage which is defined completely from this context and no `pkgs.zlib.override` is used. 

    xmlmirror = pkgs.buildEmscriptenPackage rec {
      name = "xmlmirror";

      buildInputs = [ pkgconfig autoconf automake libtool gnumake libxml2 nodejs openjdk json_c ];
      nativeBuildInputs = [ pkgconfig zlib ];

      src = pkgs.fetchgit {
        url = "https://gitlab.com/odfplugfest/xmlmirror.git";
        rev = "4fd7e86f7c9526b8f4c1733e5c8b45175860a8fd";
        sha256 = "1jasdqnbdnb83wbcnyrp32f36w3xwhwp0wq8lwwmhqagxrij1r4b";
      };

      configurePhase = ''
        rm -f fastXmlLint.js*
        # a fix for ERROR:root:For asm.js, TOTAL_MEMORY must be a multiple of 16MB, was 234217728
        # https://gitlab.com/odfplugfest/xmlmirror/issues/8
        sed -e "s/TOTAL_MEMORY=234217728/TOTAL_MEMORY=268435456/g" -i Makefile.emEnv
        # https://github.com/kripken/emscripten/issues/6344
        # https://gitlab.com/odfplugfest/xmlmirror/issues/9
        sed -e "s/\$(JSONC_LDFLAGS) \$(ZLIB_LDFLAGS) \$(LIBXML20_LDFLAGS)/\$(JSONC_LDFLAGS) \$(LIBXML20_LDFLAGS) \$(ZLIB_LDFLAGS) /g" -i Makefile.emEnv
        # https://gitlab.com/odfplugfest/xmlmirror/issues/11
        sed -e "s/-o fastXmlLint.js/-s EXTRA_EXPORTED_RUNTIME_METHODS='[\"ccall\", \"cwrap\"]' -o fastXmlLint.js/g" -i Makefile.emEnv
      '';

      buildPhase = ''
        HOME=$TMPDIR
        make -f Makefile.emEnv
      '';

      outputs = [ "out" "doc" ];

      installPhase = ''
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
      '';
      checkPhase = ''

      '';
    }; 

### Declarative debugging

Use `nix-shell -I nixpkgs=/some/dir/nixpkgs -A emscriptenPackages.libz` and from there you can go trough the individual steps. This makes it easy to build a good `unit test` or list the files of the project.

1. `nix-shell -I nixpkgs=/some/dir/nixpkgs -A emscriptenPackages.libz`
2. `cd /tmp/`
3. `unpackPhase`
4. cd libz-1.2.3
5. `configurePhase`
6. `buildPhase`
7. ... happy hacking...

## Summary

Using this toolchain makes it easy to leverage `nix` from NixOS, MacOSX or even Windows (WSL+ubuntu+nix). This toolchain is reproducible, behaves like the rest of the packages from nixpkgs and contains a set of well working examples to learn and adapt from.

If in trouble, ask the maintainers.

