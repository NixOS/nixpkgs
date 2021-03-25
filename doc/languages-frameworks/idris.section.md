# Idris {#idris}

## Installing Idris

The easiest way to get a working idris version is to install the `idris` attribute:

```
$ # On NixOS
$ nix-env -i nixos.idris
$ # On non-NixOS
$ nix-env -i nixpkgs.idris
```

This however only provides the `prelude` and `base` libraries. To install idris with additional libraries, you can use the `idrisPackages.with-packages` function, e.g. in an overlay in `~/.config/nixpkgs/overlays/my-idris.nix`:

```nix
self: super: {
  myIdris = with self.idrisPackages; with-packages [ contrib pruviloj ];
}
```

And then:

```
$ # On NixOS
$ nix-env -iA nixos.myIdris
$ # On non-NixOS
$ nix-env -iA nixpkgs.myIdris
```

To see all available Idris packages:
```
$ # On NixOS
$ nix-env -qaPA nixos.idrisPackages
$ # On non-NixOS
$ nix-env -qaPA nixpkgs.idrisPackages
```

Similarly, entering a `nix-shell`:
```
$ nix-shell -p 'idrisPackages.with-packages (with idrisPackages; [ contrib pruviloj ])'
```

## Starting Idris with library support

To have access to these libraries in idris, call it with an argument `-p <library name>` for each library:

```
$ nix-shell -p 'idrisPackages.with-packages (with idrisPackages; [ contrib pruviloj ])'
[nix-shell:~]$ idris -p contrib -p pruviloj
```

A listing of all available packages the Idris binary has access to is available via `--listlibs`:

```
$ idris --listlibs
00prelude-idx.ibc
pruviloj
base
contrib
prelude
00pruviloj-idx.ibc
00base-idx.ibc
00contrib-idx.ibc
```

## Building an Idris project with Nix

As an example of how a Nix expression for an Idris package can be created, here is the one for `idrisPackages.yaml`:

```nix
{ lib
, build-idris-package
, fetchFromGitHub
, contrib
, lightyear
}:
build-idris-package  {
  name = "yaml";
  version = "2018-01-25";

  # This is the .ipkg file that should be built, defaults to the package name
  # In this case it should build `Yaml.ipkg` instead of `yaml.ipkg`
  # This is only necessary because the yaml packages ipkg file is
  # different from its package name here.
  ipkgName = "Yaml";
  # Idris dependencies to provide for the build
  idrisDeps = [ contrib lightyear ];

  src = fetchFromGitHub {
    owner = "Heather";
    repo = "Idris.Yaml";
    rev = "5afa51ffc839844862b8316faba3bafa15656db4";
    sha256 = "1g4pi0swmg214kndj85hj50ccmckni7piprsxfdzdfhg87s0avw7";
  };

  meta = with lib; {
    description = "Idris YAML lib";
    homepage = "https://github.com/Heather/Idris.Yaml";
    license = licenses.mit;
    maintainers = [ maintainers.brainrape ];
  };
}
```

Assuming this file is saved as `yaml.nix`, it's buildable using

```
$ nix-build -E '(import <nixpkgs> {}).idrisPackages.callPackage ./yaml.nix {}'
```

Or it's possible to use

```nix
with import <nixpkgs> {};

{
  yaml = idrisPackages.callPackage ./yaml.nix {};
}
```

in another file (say `default.nix`) to be able to build it with

```
$ nix-build -A yaml
```

## Passing options to `idris` commands

The `build-idris-package` function provides also optional input values to set additional options for the used `idris` commands.

Specifically, you can set `idrisBuildOptions`, `idrisTestOptions`, `idrisInstallOptions` and `idrisDocOptions` to provide additional options to the `idris` command respectively when building, testing, installing and generating docs for your package.

For example you could set

```
build-idris-package {
  idrisBuildOptions = [ "--log" "1" "--verbose" ]

  ...
}
```

to require verbose output during `idris` build phase.
