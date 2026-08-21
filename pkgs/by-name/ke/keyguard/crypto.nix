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

  cargoHash = "sha256-xb51bzQH75YSwO25P7FShvywqcSbyHLmpF2c29TYGoM=";

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
