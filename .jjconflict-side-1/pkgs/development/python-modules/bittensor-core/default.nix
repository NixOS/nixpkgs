{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  pkg-config,
  libsodium,
  openssl,
}:

buildPythonPackage (finalAttrs: {
  pname = "bittensor-core";
  version = "0.1.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "bittensor_core";
    inherit (finalAttrs) version;
    hash = "sha256-yKSz88Vgu12cI8Y1pOABIsPvQls6oAgyAIeOswYNKkc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-SxQGYwlrGpOX8J1yNGFjdR1YYoUvZbERHgX0IjzyJW4=";
  };

  nativeBuildInputs = [
    pkg-config
  ]
  ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [
    libsodium
    openssl
  ];

  # upstream builds both from source to keep its wheels manylinux-portable
  env = {
    OPENSSL_NO_VENDOR = true;
    SODIUM_USE_PKG_CONFIG = true;
  };

  # no Python tests; the sole Rust test needs a localnet node
  doCheck = false;

  pythonImportsCheck = [ "bittensor_core" ];

  meta = {
    description = "Key, timelock and SCALE codec primitives for Bittensor clients";
    homepage = "https://github.com/RaoFoundation/subtensor";
    changelog = "https://pypi.org/project/bittensor-core/${finalAttrs.version}/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kilyanni ];
  };
})
