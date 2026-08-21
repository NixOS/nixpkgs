{
  lib,
  src,
  version,

  libx11,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "keyguard-lib";
  inherit src version;

  sourceRoot = "${src.name}/desktopLibNative/src";

  cargoHash = "sha256-VxQk7eQPfM4iH65F6yY1AqgcFC3pzlLGxljyVWJKzb4=";

  buildInputs = [ libx11 ];

  meta = {
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
