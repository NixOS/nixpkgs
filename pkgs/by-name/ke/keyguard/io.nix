{
  lib,
  src,
  version,

  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "keyguard-io-jni";
  inherit src version;

  sourceRoot = "${src.name}/util/io/rust";

  cargoHash = "sha256-duQ31LuDdb9nlGZqnmtc9y3YERRDgk9Tus16rD4zVUI=";

  cargoBuildFlags = [
    "--package"
    "keyguard-io-jni"
  ];

  meta = {
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
