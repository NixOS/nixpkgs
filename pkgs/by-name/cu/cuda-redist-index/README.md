# `cuda-redist-index`

## Roadmap

- \[ \] Improve dependency resolution by being less strict with versions.
- \[ \] Further documentation.
- \[ \] Test cases.

## Overview

This package provides a script which helps maintain the CUDA redistributable packages in Nixpkgs. It is meant to be used as part of the process of updating the manifests or supported CUDA versions in Nixpkgs. It is not meant to be used directly by users.

### `mk-index-of-package-info`

- Reads the index produced by the script `mk-index-of-sha256-and-relative-path`, which is packaged in `pkgs/by-name/cu/cuda-redist-lib` as the default executable.
- Unpacks the tarballs and creates a mapping between tarball hash and the store path of the unpacked tarball.
- Creates a mapping between the unpacked tarball store path and a feature object, describing the functionality (and directory structure) of the redistributable. This information is used by Nixpkgs to determine which outputs to provide.
- Creates a mapping between the unpacked tarball store path and the recursive NAR hash of the unpacked tarball. This information is used by Nixpkgs to treat the redistributables as Fixed Output Derivations.
- Composes the results of the prior stages, creating a deeply-nested JSON object. Instead of the values being the SRI hashes of the tarballs, they are the NAR hashes of the unpacked tarballs, which map to the feature object for that redistributable.

## Usage

> [!Note]
>
> `mk-index-of-sha256-and-relative-path` must be run before `mk-index-of-package-info`, and the index produced by `mk-index-of-sha256-and-relative-path` must be present in `pkgs/development/cuda-modules/redist-index/data/indices/sha256-and-relative-path.json` and checked in to git.

> [!Important]
>
> `mk-index-of-package-info` requires a large amount of free space in the Nix store, since it will download every tarball from every NVIDIA manifest and unpack it. As of the time of writing, the closure of this package is about 500 GB.

Make or update the indices with (from the root directory of Nixpkgs):

```bash
nix run --builders "" --offline -L .#cuda-redist-lib
git add pkgs/development/cuda-modules/redist-index/data/indices/sha256-and-relative-path.json
NIXPKGS_ALLOW_UNFREE=1 nix run --impure --builders "" --offline -L .#cuda-redist-index
git add pkgs/development/cuda-modules/redist-index/modules/data/indices/package-info.json
```
