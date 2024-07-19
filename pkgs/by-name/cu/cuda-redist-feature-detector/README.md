# `cuda-redist-feature-detector`

## Roadmap

- \[ \] Improve dependency resolution by being less strict with versions.
- \[ \] Further documentation.
- \[ \] Test cases.

## Overview

This package provides a script which helps maintain the CUDA redistributable packages in Nixpkgs. It is meant to be used as part of the process of updating the manifests or supported CUDA versions in Nixpkgs. It is not meant to be used directly by users.

### Implemented Feature Detectors

These live in `cuda_redist_feature_detector/detectors`.

- `cuda_architectures.py`: Runs `cuobjdump` on the unpacked archive to find the CUDA architectures it supports.
- `cuda_versions_in_lib.py`: Checks for subdirectories in `lib` named after CUDA versions.
- `dynamic_library.py`: Checks if the unpacked archive contains a `lib` directory with dynamic libraries.
- `executable.py`: Checks if the unpacked archive contains executables in `bin`.
- `header.py`: Checks if the unpacked archive contains a `include` directory with headers.
- `needed_libs.py`: Runs `patchelf --print-needed` on the unpacked archive to find the libraries it needs.
- `provided_libs.py`: Runs `patchelf --print-soname` on the unpacked archive to find the libraries it provides.
- `python_module.py`: Checks if the unpacked archive contains a `site-packages` directory with Python modules.
- `static_library.py`: Checks if the unpacked archive contains a `lib` directory with static libraries.
- `stubs.py`: Checks if the unpacked archive contains a `stubs` or `lib/stubs` directory.

## Usage

TODO(@connorbaker)
