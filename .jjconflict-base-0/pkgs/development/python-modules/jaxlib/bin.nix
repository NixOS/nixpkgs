# For the moment we only support the CPU and GPU backends of jaxlib. The TPU
# backend will require some additional work. Those wheels are located here:
# https://storage.googleapis.com/jax-releases/libtpu_releases.html.

# See `python3Packages.jax.passthru` for CUDA tests.

{
  absl-py,
  autoPatchelfHook,
  buildPythonPackage,
  fetchPypi,
  flatbuffers,
  lib,
  ml-dtypes,
  python,
  scipy,
  stdenv,
}:

let
  version = "0.6.0";
  inherit (python) pythonVersion;

  # As of 2023-06-06, google/jax upstream is no longer publishing CPU-only wheels to their GCS bucket. Instead the
  # official instructions recommend installing CPU-only versions via PyPI.
  srcs =
    let
      getSrcFromPypi =
        {
          platform,
          dist,
          hash,
        }:
        fetchPypi {
          inherit
            version
            platform
            dist
            hash
            ;
          pname = "jaxlib";
          format = "wheel";
          # See the `disabled` attr comment below.
          python = dist;
          abi = dist;
        };
    in
    {
      "3.10-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp310";
        hash = "sha256-pNQlTHEziIh6MhN508WxogITqNzckD+vFRObqB4+zWE=";
      };
      "3.10-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp310";
        hash = "sha256-VBpBi5iyjfW9Oh6TxistP2TUSwxwt7YI9/4rSqRSsq8=";
      };
      "3.10-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp310";
        hash = "sha256-ZKgvjrQP23uh1G75BzANQuT5jL2pYCou2OcNsamsSmA=";
      };

      "3.11-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp311";
        hash = "sha256-vtRVJeO7XsCGML/SB8Ca+dYun/E/XwfC7iz9jthBG6E=";
      };
      "3.11-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp311";
        hash = "sha256-wK6VmJmALhMpzI7ForTUvpoHa1vrIFLrSbo3UU5iPrw=";
      };
      "3.11-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp311";
        hash = "sha256-7xY88H3gC8VpAWnpf6+q3DePHDgfAofopHPnirW6sbU=";
      };

      "3.12-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp312";
        hash = "sha256-tthbjR/XkkiwRQNRcgHnL8vNOYDPeR036BRwnqUKPII=";
      };
      "3.12-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp312";
        hash = "sha256-JTb6k+wUjVAW2osgd7pmMlsNhqriKJphwSaHfwQrPRw=";
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
        hash = "sha256-fjzi7w7cm0izbicEw2GB8eznoSrBFN91PbQobqLG6Lg=";
      };

      "3.13-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp313";
        hash = "sha256-0PsSLceDDKKlyjyHSghzY6AFMrZEUJwhnDv9HVRRXo0=";
      };
      "3.13-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp313";
        hash = "sha256-GJcpY5diBQwXgLBQ6Y/2IEgLHqMr8WdTPgAKXPTFc44=";
      };
      "3.13-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp313";
        hash = "sha256-xOl5NMuvUXI0OqWujvDFhGLOJhVN/adUICswNBYMrHs=";
      };
    };
in
buildPythonPackage {
  pname = "jaxlib";
  inherit version;
  format = "wheel";

  # See https://discourse.nixos.org/t/ofborg-does-not-respect-meta-platforms/27019/6.
  src = (
    srcs."${pythonVersion}-${stdenv.hostPlatform.system}"
      or (throw "jaxlib-bin is not supported on ${stdenv.hostPlatform.system}")
  );

  # Prebuilt wheels are dynamically linked against things that nix can't find.
  # Run `autoPatchelfHook` to automagically fix them.
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  # Dynamic link dependencies
  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  dependencies = [
    absl-py
    flatbuffers
    ml-dtypes
    scipy
  ];

  pythonImportsCheck = [ "jaxlib" ];

  meta = {
    description = "Prebuilt jaxlib backend from PyPi";
    homepage = "https://github.com/google/jax";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
    badPlatforms = [
      # Fails at pythonImportsCheckPhase:
      # ...-python-imports-check-hook.sh/nix-support/setup-hook: line 10: 28017 Illegal instruction: 4
      # /nix/store/5qpssbvkzfh73xih07xgmpkj5r565975-python3-3.11.9/bin/python3.11 -c
      # 'import os; import importlib; list(map(lambda mod: importlib.import_module(mod), os.environ["pythonImportsCheck"].split()))'
      "x86_64-darwin"
    ];
  };
}
