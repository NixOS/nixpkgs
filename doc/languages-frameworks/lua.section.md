---
title: Lua
author: Matthieu Coudron
date: 2018-03-01
---

# User's Guide to Lua Infrastructure

## Using Lua

### Overview of Lua

Several versions of the Lua interpreter are available: luajit, lua5.1, 5.2, 5.3.
The architecture is very similar to python's so you can mostly replace `python`
with lua in the previous documentation.
The attribute `lua` refers to the default interpreter, which is currently Lua5.1. It is also possible to refer to specific versions, e.g. `lua_52` refers to Lua 5.2.

Lua libraries are in separate sets, with one set per interpreter version.

The interpreters have several common attributes. One of these attributes is
`pkgs`, which is a package set of Lua libraries for this specific
interpreter. E.g., the `busted` package corresponding to the default interpreter
is `python.pkgs.busted`, and the lua 5.2 version is lua_52.pkgs.busted`.
The main package set contains aliases to these package sets, e.g.
`luaPackages` refers to `lua_51.pkgs` and `lua_52Packages` to
`lua_52.pkgs`.

### Installing Lua and packages

#### Lua environment defined in separate `.nix` file

Create a file, e.g. `build.nix`, with the following expression
```nix
with import <nixpkgs> {};

lua_52.withPackages (ps: with ps; [ busted luafilesystem ])
```
and install it in your profile with
```shell
nix-env -if build.nix
```
Now you can use the Lua interpreter, as well as the extra packages (`busted`,
`luafilesystem`) that you added to the environment.

#### Lua environment defined in `~/.config/nixpkgs/config.nix`

If you prefer to, you could also add the environment as a package override to the Nixpkgs set, e.g.
using `config.nix`,
```nix
{ # ...

  packageOverrides = pkgs: with pkgs; {
    myLuaEnv = lua_52.withPackages (ps: with ps; [ busted luafilesystem ]);
  };
}
```
and install it in your profile with
```shell
nix-env -iA nixpkgs.myLuaEnv
```
The environment is is installed by referring to the attribute, and considering
the `nixpkgs` channel was used.

#### Lua environment defined in `/etc/nixos/configuration.nix`

For the sake of completeness, here's another example how to install the environment system-wide.

```nix
{ # ...

  environment.systemPackages = with pkgs; [
    (lua.withPackages(ps: with ps; [ busted luafilesystem ]))
  ];
}
```

### Temporary Lua environment with `nix-shell`

For development you may need to use multiple environments.
`nix-shell` gives the possibility to temporarily load another environment, akin
to `virtualenv`.

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


## Developing with Lua

Now that you know how to get a working Lua environment with Nix, it is time
to go forward and start actually developing with Lua. There are two ways to
package lua software, either it is on luarocks and most of it can be taken care
of by the luarocks2nix converter or the packaging has to be done manually.
Let's present the luarocks way first and the manual one in a second time.

### Packaging a library on luarocks

Luarocks.org is the main repository of lua packages. The site proposes two types of packages, the rockspec and the src.rock (equivalent of a rockspec but with the source). These packages can have different build types such as `cmake`, `builtin` etc (See https://github.com/luarocks/luarocks/wiki/Rockspec-format).

A list of luarocks generated packages is visible at pkgs/top-level/lua-generated-packages.nix.


Luarocks2nix is a tool capable of generating nix derivations from a rockspec file but there are at the moment some limits
1. The nix derivation will try to fetch the sources from the src.rock file.
   This can be worked around by using `luarocks pack <PKG>.rockspec` and then
   upload the file on luarocks.org.
2. nix won't work with all packages. If the package lists `external_dependencies` in its rockspec file then it won't work.

You can run `nix-shell -p luarocks-nix` and then `luarocks nix PKG_NAME`.
Once you have checked the package works without modifications, you can add it to `maintainers/scripts/luarocks.sh`
Nix rely on luarocks to install lua packages, basically it runs:
`luarocks make --deps-mode=none --tree $out`

#### Packaging a library manually

You can develop your package as you usually would, just don't forget to wrap it
within a `toLuaModule` call.



## Lua Reference

### Lua interpreters

Versions 5.1, 5.2 and 5.3 of the lua interpreter are available as
respectively `lua_51`, `lua_52` and `lua_53`.
The default interpreter, `lua`, maps to `lua_51`. The luajit interpreter is also available.
The Nix expressions for the interpreters can be found in
`pkgs/development/interpreters/lua`.

All packages depending on any Lua interpreter get appended
`out/share/{lua.version}/?.lua` to `$LUA_PATH` if such directory
exists.

#### Attributes on lua interpreters packages

Each interpreter has the following attributes:

- `interpreter`. Alias for `${lua}/bin/lua`.
- `buildEnv`. Function to build python interpreter environments with extra packages bundled together. See section *python.buildEnv function* for usage and documentation.
- `withPackages`. Simpler interface to `buildEnv`.
- `pkgs`. Set of Lua packages for that specific interpreter. The package set can be modified by overriding the interpreter and passing `packageOverrides`.


#### `buildLuarocksPackage` function

The `buildLuarocksPackage` function is implemented in `pkgs/development/interpreters/lua-5/build-lua-package.nix`
The following is an example:
```nix
luaexpat = buildLuaPackage rec {
  pname = "luaexpat";
  version = "1.3.0-1";

  src = fetchurl {
    url    = https://luarocks.org/luaexpat-1.3.0-1.src.rock;
    sha256 = "15jqz5q12i9zvjyagzwz2lrpzya64mih8v1hxwr0wl2gsjh86y5a";
  };
  disabled = luaOlder "5.1";

  propagatedBuildInputs = [ lua ];

  buildType="builtin";

  meta = {
    homepage = http://www.keplerproject.org/luaexpat/;
    description="XML Expat parsing";
    license = {
      fullName = "MIT/X11";
    };
  };
};
```

The `buildLuarocksPackage` delegates most tasks to luarocks:

* it adds `luarocks` as an unpacker for `src.rock` files (in fact zip files)
* configurePhase` writes a temporary luarocks configuration file which location
is exported via the environment variable `LUAROCKS_CONFIG`.
* In the `buildPhase`, nothing is done.
* `installPhase` calls `luarocks make --deps-mode=none --tree $out` to build and
install the package
* In the `postFixup` phase, the `wrapLuaPrograms` bash function is called to
  wrap all programs in the `$out/bin/*` directory to include `$PATH`
  environment variable and add dependent libraries to script's `LUA_PATH` and
  `LUA_CPATH`.

As in Perl, dependencies on other Lua packages can be specified in the
`buildInputs` and `propagatedBuildInputs` attributes.  If something is
exclusively a build-time dependency, use `buildInputs`; if it’s  a runtime
dependency, use `propagatedBuildInputs`.

By default `meta.platforms` is set to the same value
as the interpreter unless overridden otherwise.

#### `buildLuaApplication` function

The `buildLuaApplication` function is practically the same as `buildLuaPackage`.
The difference is that `buildLuaPackage` by default prefixes the names of the packages with the version of the interpreter.
Because with an application we're not interested in multiple version the prefix is dropped.

#### lua.withPackages function

The `lua.withPackages` function provides a simpler interface to the `python.buildEnv` functionality.
It takes a function as an argument that is passed the set of python packages and returns the list
of the packages to be included in the environment. Using the `withPackages` function, the previous
example for the luafilesystem environment can be written like this:
```nix
with import <nixpkgs> {};

lua.withPackages (ps: [ps.luafilesystem])
```

`withPackages` passes the correct package set for the specific interpreter version as an argument to the function. In the above example, `ps` equals `luaPackages`.
But you can also easily switch to using lua_52:
```nix
with import <nixpkgs> {};

lua_52.withPackages (ps: [ps.lua])
```

Now, `ps` is set to `lua_52Packages`, matching the version of the interpreter.

### Lua/nixpkgs ecosystem

Lua packages can be generated with the tool after being added to the whitelist in
maintainers/scripts/update-luarocks-packages.sh

Packages inside nixpkgs are written by hand.

- [luarocks2nix](https://github.com/teto/luarocks)


### Possible Todos

* support rockspecs
* export/use version specific variables such as LUA_PATH_5_2/LUAROCKS_CONFIG_5_2
* let luarocks check for dependencies via exporting the different rocktrees in temporary config
* add luarocks supported_platforms support to luarocks2nix]]

### Lua Contributing guidelines

Following rules should be respected:

* Make sure libraries build for all Lua interpreters.
* Commit names of Lua libraries should reflect that they are Lua libraries, so write for example `lua.luafilesystem: 1.11 -> 1.12`.

