{
  lib,
  src,
  version,

  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "keyguard-gpg-agent";
  inherit src version;

  sourceRoot = "${src.name}/desktopGpgAgent/src";

  cargoHash = "sha256-HGx+5xkL6auib3gtyd6EQQXIAZCDLY0bhnBpeVppKPI=";

  nativeBuildInputs = [ protobuf ];

  meta = {
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
