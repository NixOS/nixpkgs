{
  lib,
  src,
  version,

  cmake,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "keyguard-crypto-jni";
  inherit src version;

  sourceRoot = "${src.name}/util/crypto/rust";

  cargoHash = "sha256-yVdQyGWc1wKkltjBHAPLxOmxZM/55H/t95oKZBnMHOE=";

  cargoBuildFlags = [
    "--package"
    "keyguard-crypto-jni"
  ];

  nativeBuildInputs = [ cmake ];
  env.AWS_LC_SYS_CMAKE_BUILDER = 1;

  meta = {
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
