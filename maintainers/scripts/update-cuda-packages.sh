#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# DESRCIPTION:
#   Updates NVIDIA CUDA packages (`cudaPackages`) from cuda-redist and runfile.
#
# AUTHOR:
#   Adam Erickson (Nervosys)
#
# DATE:
#   2024-05-01
#
# OPTIONAL:
#   - Updated supported GPUs here: pkgs/development/cuda-modules/gpus.nix
#
# NOTES:
#   - Assumes CUDA_VERSION_MAJOR_MINOR_PREVIOUS was a minor version decrement
#   - For documentation, see `nixpkgs/doc/languages-frameworks/cuda_section.md`
# -----------------------------------------------------------------------------

set -e                      # exit on error
[ "$DEBUG" = 1 ] && set -x  # print program trace

###
### Variables
###

# Static: defaults
CUDA_VERSION='12.4.1'
CUTENSOR_VERSION='2.0.1'
CUDA_RUNFILE_URL='https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda_12.4.1_550.54.15_linux.run'

###
### Functions
###

function usage {
    printf "\nUsage: %s [-c|--cuda] CUDA_VERSION [-t|--tensor] CUTENSOR_VERSION\n" $0
}

###
### Main
###

# Parse command-line interface (CLI) arguments.
while [[ $# -gt 0 ]]; do
  case $1 in
    -c|--cuda)
      CUDA_VERSION="$2"
      shift  # past argument
      shift  # past value
      ;;
    -t|--cutensor)
      CUTENSOR_VERSION="$2"
      shift  # past argument
      shift  # past value
      ;;
    -u|--cuda-runfile-url)
      CUDA_RUNFILE_URL="$2"
      shift  # past argument
      shift  # past value
      ;;
    -*|--*)
      echo "Error: unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

# Dynamic variables
CUDA_VERSION_MAJOR_MINOR="${CUDA_VERSION%.*}"
CUDA_VERSION_MAJOR_MINOR_UNDER="${CUDA_VERSION_MAJOR_MINOR/./_}"
CUDA_VERSION_MAJOR_MINOR_PREVIOUS="$(echo "scale=10; ${CUDA_VERSION_MAJOR_MINOR} - 0.1" | bc -l)"
CUDA_VERSION_MAJOR_MINOR_PREVIOUS_UNDER="${CUDA_VERSION_MAJOR_MINOR_PREVIOUS/./_}"

echo '-----------------------------------------------'
echo " CUDA version new:      ${CUDA_VERSION} || ${CUDA_VERSION_MAJOR_MINOR} || ${CUDA_VERSION_MAJOR_MINOR_UNDER}"
echo " CUDA version previous:        || ${CUDA_VERSION_MAJOR_MINOR_PREVIOUS} || ${CUDA_VERSION_MAJOR_MINOR_PREVIOUS_UNDER}"
echo '-----------------------------------------------'

### Download and process manifests.

# Update CUDA: download and process manifests.
nix run github:connorbaker/cuda-redist-find-features -- \
    download-manifests \
    --log-level DEBUG \
    --version "$CUDA_VERSION" \
    https://developer.download.nvidia.com/compute/cuda/redist \
    ./pkgs/development/cuda-modules/cuda/manifests

nix run github:connorbaker/cuda-redist-find-features -- \
    process-manifests \
    --log-level DEBUG \
    --version "$CUDA_VERSION" \
    https://developer.download.nvidia.com/compute/cuda/redist \
    ./pkgs/development/cuda-modules/cuda/manifests

# Update the `cudaVersionMap` attribute set in `pkgs/development/cuda-modules/cuda/extension.nix`.
# Append the new version information.
sed -i "/\"${CUDA_VERSION_MAJOR_MINOR_PREVIOUS}\" = .*$/a\    \"${CUDA_VERSION_MAJOR_MINOR}\" = \"${CUDA_VERSION}\";" \
    ./pkgs/development/cuda-modules/cuda/extension.nix

# Update cuTensor: download and process manifests.
nix run github:connorbaker/cuda-redist-find-features -- \
    download-manifests \
    --log-level DEBUG \
    --version "$CUTENSOR_VERSION" \
    https://developer.download.nvidia.com/compute/cutensor/redist \
    ./pkgs/development/cuda-modules/cutensor/manifests

nix run github:connorbaker/cuda-redist-find-features -- \
    process-manifests \
    --log-level DEBUG \
    --version "$CUTENSOR_VERSION" \
    https://developer.download.nvidia.com/compute/cutensor/redist \
    ./pkgs/development/cuda-modules/cutensor/manifests

### Update supported compilers and GPUs (optional).

# Update `nvcc-compatibilities.nix` in `pkgs/development/cuda-modules/` to include the newest release of NVCC,
# as well as any newly supported host compilers.
COMPATIBILITY="
    # Sets maximum and minimum GCC versions
    # https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html#id3
    \"12.4\" = attrs.\"${CUDA_VERSION_MAJOR_MINOR_PREVIOUS}\" // {
      gccMaxMajorVersion = \"13\";
      gccMinMajorVersion = \"7\";
      gccMinMinorVersion = \"3\";
    };
"
awk -i inplace -v prev="\"${CUDA_VERSION_MAJOR_MINOR_PREVIOUS}\".*$" -v compat="$COMPATIBILITY" '$0 ~ prev{print $0; print compat;next}1' \
    ./pkgs/development/cuda-modules/nvcc-compatibilities.nix

# OPTIONAL: Update `gpus.nix` in `pkgs/development/cuda-modules/` to include any new GPUs supported by the new release of CUDA.
# Example:
# GPU="  {
#     # NVIDIA H100 (GH100) (Thor)
#     archName = \"Hopper\";
#     computeCapability = \"9.0a\";
#     isJetson = false;
#     minCudaVersion = \"12.0\";
#     dontDefaultAfter = null;
#     maxCudaVersion = null;
#   }"
# awk -v gpu="$GPU" '/^]/ && c == 0 {c = 1; print gpu}; {print}' ./pkgs/development/cuda-modules/gpus.nix

### Install runfile version for backwards compatibility.

# Download the CUDA runfile.
nix store prefetch-file --hash-type sha256 --json "$CUDA_RUNFILE_URL" > cuda_runfile_prefetch.json
CUDA_RUNFILE_HASH="$(grep -o '"hash":"[^"]*' cuda_runfile_prefetch.json | grep -o '[^"]*$')"

# Update `cudatoolkit` to include the release.
CUDA_RELEASE="
  \"${CUDA_VERSION_MAJOR_MINOR}\" = {
    version = \"${CUDA_VERSION}\";
    url = \"${CUDA_RUNFILE_URL}\";
    sha256 = \"${CUDA_RUNFILE_HASH}\";
  };
"
awk -i inplace -v release="$CUDA_RELEASE" '/}$/ && c == 0 {c = 0; print release}; {print}' \
    ./pkgs/development/cuda-modules/cudatoolkit/releases.nix

# Include a new `cudaPackages_<major>_<minor>` package set in `pkgs/top-level/all-packages.nix`.
# 'cudaPackages_<major>_<minor>' ./pkgs/top-level/all-packages.nix
# '  cudaPackages_12_3 = callPackage ./cuda-packages.nix { cudaVersion = "12.3"; };'
PATTERN="cudaPackages_${CUDA_VERSION_MAJOR_MINOR_PREVIOUS_UNDER} = callPackage"
APPEND="cudaPackages_${CUDA_VERSION_MAJOR_MINOR_UNDER} = callPackage ./cuda-packages.nix { cudaVersion = \"${CUDA_VERSION_MAJOR_MINOR}\"; };"
sed -i "/${PATTERN}.*$/a\\  ${APPEND}" ./pkgs/top-level/all-packages.nix

# Build the closure of the new package set, updating `pkgs/development/cuda-modules/cuda/overrides.nix` as needed.
echo 'Build closure of package set. Update `./pkgs/development/cuda-modules/cuda/overrides.nix` as needed.'

# Below are some common reasons for failure:
#
# | Unable to ... | During ... | Reason | Solution | Note |
# | --- | --- | --- | --- | --- |
# | Find headers | `configurePhase` or `buildPhase` | Missing dependency on a `dev` output | Add the missing dependency | The `dev` output typically contain the headers |
# | Find libraries | `configurePhase` | Missing dependency on a `dev` output | Add the missing dependency | The `dev` output typically contain CMake configuration files |
# | Find libraries | `buildPhase` or `patchelf` | Missing dependency on a `lib` or `static` output | Add the missing dependency | The `lib` or `static` output typically contain the libraries |
#
# In the scenario you are unable to run the resulting binary: this is arguably the most complicated as it could be any combination of the previous reasons. This type of failure
# typically occurs when a library attempts to load or open a library it depends on that it does not declare in its `DT_NEEDED` section. As a first step, ensure that dependencies are
# patched with [`cudaPackages.autoAddDriverRunpath`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages.autoAddDriverRunpath). Failing that, try 
# running the application with [`nixGL`](https://github.com/guibou/nixGL) or a similar wrapper tool. If that works, it likely means that the application is attempting to load a library # that is not in the `RPATH` or `RUNPATH` of the binary.

echo 'CUDA and cuTENSOR installation completed successfully.'

exit 0