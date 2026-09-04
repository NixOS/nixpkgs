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

  cargoHash = "sha256-obdHk2/P8OfOmqMUVslKDjKyTzpMIEAbW7D6zv/Vt6w=";

  buildInputs = [ libx11 ];

  meta = {
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
