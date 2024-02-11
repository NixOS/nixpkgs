# User’s Guide to Lua Infrastructure {#users-guide-to-lua-infrastructure}

## Using Lua {#using-lua}

### Overview of Lua {#overview-of-lua}

Several versions of the Lua interpreter are available: luajit, lua 5.1, 5.2, 5.3.
The attribute `lua` refers to the default interpreter, it is also possible to refer to specific versions, e.g. `lua5_2` refers to Lua 5.2.

Lua libraries are in separate sets, with one set per interpreter version.

The interpreters have several common attributes. One of these attributes is
`pkgs`, which is a package set of Lua libraries for this specific
interpreter. E.g., the `busted` package corresponding to the default interpreter
is `lua.pkgs.busted`, and the lua 5.2 version is `lua5_2.pkgs.busted`.
The main package set contains aliases to these package sets, e.g.
`luaPackages` refers to `lua5_1.pkgs` and `lua52Packages` to
`lua5_2.pkgs`.

### Installing Lua and packages {#installing-lua-and-packages}

#### Lua environment defined in separate `.nix` file {#lua-environment-defined-in-separate-.nix-file}

Create a file, e.g. `build.nix`, with the following expression

```nix
with import <nixpkgs> {};

lua5_2.withPackages (ps: with ps; [ busted luafilesystem ])
```

and install it in your profile with

```shell
nix-env -if build.nix
```
Now you can use the Lua interpreter, as well as the extra packages (`busted`,
`luafilesystem`) that you added to the environment.

#### Lua environment defined in `~/.config/nixpkgs/config.nix` {#lua-environment-defined-in-.confignixpkgsconfig.nix}

If you prefer to, you could also add the environment as a package override to the Nixpkgs set, e.g.
using `config.nix`,

```nix
{ # ...

  packageOverrides = pkgs: with pkgs; {
    myLuaEnv = lua5_2.withPackages (ps: with ps; [ busted luafilesystem ]);
  };
}
```

and install it in your profile with

```shell
nix-env -iA nixpkgs.myLuaEnv
```
The environment is installed by referring to the attribute, and considering
the `nixpkgs` channel was used.

#### Lua environment defined in `/etc/nixos/configuration.nix` {#lua-environment-defined-in-etcnixosconfiguration.nix}

For the sake of completeness, here's another example how to install the environment system-wide.

```nix
{ # ...

  environment.systemPackages = with pkgs; [
    (lua.withPackages(ps: with ps; [ busted luafilesystem ]))
  ];
}
```

### How to override a Lua package using overlays? {#how-to-override-a-lua-package-using-overlays}

Use the following overlay template:

```nix
final: prev:
{

  lua = prev.lua.override {
    packageOverrides = luaself: luaprev: {

      luarocks-nix = luaprev.luarocks-nix.overrideAttrs(oa: {
        pname = "luarocks-nix";
        src = /home/my_luarocks/repository;
      });
  };

  luaPackages = lua.pkgs;
}
```

### Temporary Lua environment with `nix-shell` {#temporary-lua-environment-with-nix-shell}


There are two methods for loading a shell with Lua packages. The first and recommended method
is to create an environment with `lua.buildEnv` or `lua.withPackages` and load that. E.g.

```sh
$ nix-shell -p 'lua.withPackages(ps: with ps; [ busted luafilesystem ])'
```

opens a shell from which you can launch the interpreter

```sh
[nix-shell:~] lua
```

The other method, which is not recommended, does not create an environment and requires you to list the packages directly,

```sh
$ nix-shell -p lua.pkgs.busted lua.pkgs.luafilesystem
```
Again, it is possible to launch the interpreter from the shell.
The Lua interpreter has the attribute `pkgs` which contains all Lua libraries for that specific interpreter.


## Developing with Lua {#developing-with-lua}

Now that you know how to get a working Lua environment with Nix, it is time
to go forward and start actually developing with Lua. There are two ways to
package lua software, either it is on luarocks and most of it can be taken care
of by the luarocks2nix converter or the packaging has to be done manually.
Let's present the luarocks way first and the manual one in a second time.

### Packaging a library on luarocks {#packaging-a-library-on-luarocks}

[Luarocks.org](https://luarocks.org/) is the main repository of lua packages.
The site proposes two types of packages, the `rockspec` and the `src.rock`
(equivalent of a [rockspec](https://github.com/luarocks/luarocks/wiki/Rockspec-format) but with the source).

Luarocks-based packages are generated in [pkgs/development/lua-modules/generated-packages.nix](https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/lua-modules/generated-packages.nix) from
the whitelist maintainers/scripts/luarocks-packages.csv and updated by running
the package `luarocks-packages-updater`:

```sh

nix-shell -p luarocks-packages-updater --run luarocks-packages-updater
```

[luarocks2nix](https://github.com/nix-community/luarocks) is a tool capable of generating nix derivations from both rockspec and src.rock (and favors the src.rock).
The automation only goes so far though and some packages need to be customized.
These customizations go in [pkgs/development/lua-modules/overrides.nix](https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/lua-modules/overrides.nix).
For instance if the rockspec defines `external_dependencies`, these need to be manually added to the overrides.nix.

You can try converting luarocks packages to nix packages with the command `nix-shell -p luarocks-nix` and then `luarocks nix PKG_NAME`.

#### Packaging a library manually {#packaging-a-library-manually}

You can develop your package as you usually would, just don't forget to wrap it
within a `toLuaModule` call, for instance

```nix
mynewlib = toLuaModule ( stdenv.mkDerivation { ... });
```

There is also the `buildLuaPackage` function that can be used when lua modules
are not packaged for luarocks. You can see a few examples at `pkgs/top-level/lua-packages.nix`.

## Lua Reference {#lua-reference}

### Lua interpreters {#lua-interpreters}

Versions 5.1, 5.2, 5.3 and 5.4 of the lua interpreter are available as
respectively `lua5_1`, `lua5_2`, `lua5_3` and `lua5_4`. Luajit is available too.
The Nix expressions for the interpreters can be found in `pkgs/development/interpreters/lua-5`.

#### Attributes on lua interpreters packages {#attributes-on-lua-interpreters-packages}

Each interpreter has the following attributes:

- `interpreter`. Alias for `${pkgs.lua}/bin/lua`.
- `buildEnv`. Function to build lua interpreter environments with extra packages bundled together. See section *lua.buildEnv function* for usage and documentation.
- `withPackages`. Simpler interface to `buildEnv`.
- `pkgs`. Set of Lua packages for that specific interpreter. The package set can be modified by overriding the interpreter and passing `packageOverrides`.

#### `buildLuarocksPackage` function {#buildluarockspackage-function}

The `buildLuarocksPackage` function is implemented in `pkgs/development/interpreters/lua-5/build-luarocks-package.nix`
The following is an example:
```nix
luaposix = buildLuarocksPackage {
  pname = "luaposix";
  version = "34.0.4-1";

  src = fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/luaposix-34.0.4-1.src.rock";
    hash = "sha256-4mLJG8n4m6y4Fqd0meUDfsOb9RHSR0qa/KD5KCwrNXs=";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ bit32 lua std_normalize ];

  meta = with lib; {
    homepage = "https://github.com/luaposix/luaposix/";
    description = "Lua bindings for POSIX";
    maintainers = with maintainers; [ vyp lblasc ];
    license.fullName = "MIT/X11";
  };
};
```

The `buildLuarocksPackage` delegates most tasks to luarocks:

* it adds `luarocks` as an unpacker for `src.rock` files (zip files really).
* `configurePhase` writes a temporary luarocks configuration file which location
is exported via the environment variable `LUAROCKS_CONFIG`.
* the `buildPhase` does nothing.
* `installPhase` calls `luarocks make --deps-mode=none --tree $out` to build and
install the package
* In the `postFixup` phase, the `wrapLuaPrograms` bash function is called to
  wrap all programs in the `$out/bin/*` directory to include `$PATH`
  environment variable and add dependent libraries to script's `LUA_PATH` and
  `LUA_CPATH`.

By default `meta.platforms` is set to the same value as the interpreter unless overridden otherwise.

#### `buildLuaApplication` function {#buildluaapplication-function}

The `buildLuaApplication` function is practically the same as `buildLuaPackage`.
The difference is that `buildLuaPackage` by default prefixes the names of the packages with the version of the interpreter.
Because with an application we're not interested in multiple version the prefix is dropped.

#### lua.withPackages function {#lua.withpackages-function}

The `lua.withPackages` takes a function as an argument that is passed the set of lua packages and returns the list of packages to be included in the environment.
Using the `withPackages` function, the previous example for the luafilesystem environment can be written like this:

```nix
with import <nixpkgs> {};

lua.withPackages (ps: [ps.luafilesystem])
```

`withPackages` passes the correct package set for the specific interpreter version as an argument to the function. In the above example, `ps` equals `luaPackages`.
But you can also easily switch to using `lua5_2`:

```nix
with import <nixpkgs> {};

lua5_2.withPackages (ps: [ps.lua])
```

Now, `ps` is set to `lua52Packages`, matching the version of the interpreter.

### Possible Todos {#possible-todos}

* export/use version specific variables such as `LUA_PATH_5_2`/`LUAROCKS_CONFIG_5_2`
* let luarocks check for dependencies via exporting the different rocktrees in temporary config

### Lua Contributing guidelines {#lua-contributing-guidelines}

Following rules should be respected:

* Make sure libraries build for all Lua interpreters.
* Commit names of Lua libraries should reflect that they are Lua libraries, so write for example `luaPackages.luafilesystem: 1.11 -> 1.12`.
