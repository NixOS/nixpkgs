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

  cargoHash = "sha256-OITT6/aUjPPVlcbJO36zp6fndx3K4hmWzKwewVNMq9c=";

  nativeBuildInputs = [ protobuf ];

  meta = {
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
