# Crystal {#crystal}

## Building a Crystal package {#building-a-crystal-package}

This section uses [Mint](https://github.com/mint-lang/mint) as an example for how to build a Crystal package.

If the Crystal project has any dependencies, the first step is to get a `shards.nix` file encoding those. Get a copy of the project and go to its root directory such that its `shard.lock` file is in the current directory. Executable projects should usually commit the `shard.lock` file, but sometimes that's not the case, which means you need to generate it yourself. With an existing `shard.lock` file, `crystal2nix` can be run.
```bash
$ git clone https://github.com/mint-lang/mint
$ cd mint
$ git checkout 0.5.0
$ if [ ! -f shard.lock ]; then nix-shell -p shards --run "shards lock"; fi
$ nix-shell -p crystal2nix --run crystal2nix
```

This should have generated a `shards.nix` file.

Next create a Nix file for your derivation and use `pkgs.crystal.buildCrystalPackage` as follows:

```nix
with import <nixpkgs> {};
crystal.buildCrystalPackage rec {
  pname = "mint";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mint-lang";
    repo = "mint";
    rev = version;
    hash = "sha256-dFN9l5fgrM/TtOPqlQvUYgixE4KPr629aBmkwdDoq28=";
  };

  # Insert the path to your shards.nix file here
  shardsFile = ./shards.nix;

  ...
}
```

This won't build anything yet, because we haven't told it what files build. We can specify a mapping from binary names to source files with the `crystalBinaries` attribute. The project's compilation instructions should show this. For Mint, the binary is called "mint", which is compiled from the source file `src/mint.cr`, so we'll specify this as follows:

```nix
  crystalBinaries.mint.src = "src/mint.cr";

  # ...
```

Additionally you can override the default `crystal build` options (which are currently `--release --progress --no-debug --verbose`) with

```nix
  crystalBinaries.mint.options = [ "--release" "--verbose" ];
```

Depending on the project, you might need additional steps to get it to compile successfully. In Mint's case, we need to link against openssl, so in the end the Nix file looks as follows:

```nix
with import <nixpkgs> {};
crystal.buildCrystalPackage rec {
  version = "0.5.0";
  pname = "mint";
  src = fetchFromGitHub {
    owner = "mint-lang";
    repo = "mint";
    rev = version;
    hash = "sha256-dFN9l5fgrM/TtOPqlQvUYgixE4KPr629aBmkwdDoq28=";
  };

  shardsFile = ./shards.nix;
  crystalBinaries.mint.src = "src/mint.cr";

  buildInputs = [ openssl ];
}
```
