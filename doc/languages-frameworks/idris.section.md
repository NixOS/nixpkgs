# Idris packages

## Installing Idris

The easiest way to get a working idris version is to install the `idris` attribute:

```
$ # On NixOS
$ nix-env -i nixos.idris
$ # On non-NixOS
$ nix-env -i nixpkgs.idris
```

This however only provides the `prelude` and `base` libraries. To install additional libraries:

```
$ nix-env -iE 'pkgs: pkgs.idrisPackages.with-packages (with pkgs.idrisPackages; [ contrib pruviloj ])'
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
{ build-idris-package
, fetchFromGitHub
, contrib
, lightyear
, lib
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

  meta = {
    description = "Idris YAML lib";
    homepage = https://github.com/Heather/Idris.Yaml;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
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
