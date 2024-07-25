# `cuda-redist-lib`

## Roadmap

- \[ \] Improve dependency resolution by being less strict with versions.
- \[ \] Further documentation.
- \[ \] Test cases.

## Overview

This package provides library functions which help maintain the CUDA redistributable packages in Nixpkgs. It is meant to be used as part of the process of updating the manifests or supported CUDA versions in Nixpkgs. It is not meant to be used directly by users.

### `mk-index-of-sha256-and-relative-path`

Available as the default executable of `cuda-redist-lib`, the `mk-index-of-sha256-and-relative-path` script retrieves and processes the manifests from NVIDIA's website. 

> [!Note]
>
> The `tensorrt` directory contains hand-made manifests meant to mimic the structure of NVIDIA's manifests for their other redistributables. They add TensorRT to the generated index.

The result is a deeply-nested JSON object where the keys are various fields, and the leaves of the tree are the SRI hashes of the tarballs and the relative path to the tarball, if we cannot reconstruct it from the context of the tree. The result is written to `pkgs/development/cuda-modules/redist-index/data/indices/sha256-and-relative-path.json`, as is required by the `mk-index-of-package-info` script packaged in `pkgs/by-name/cu/cuda-redist-index`. 

## Usage

Make or update the indices with (from the root directory of Nixpkgs):

```bash
nix run --builders "" --offline -L .#cuda-redist-lib
git add pkgs/development/cuda-modules/redist-index/data/indices/sha256-and-relative-path.json
```
