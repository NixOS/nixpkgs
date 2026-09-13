{
  lib,
  src,
  version,

  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "keyguard-ssh-agent";
  inherit src version;

  sourceRoot = "${src.name}/desktopSshAgent/src";

  cargoHash = "sha256-TKHr8v5bHPsEkUlvg5KW0FWEnS0mWG1ec0tFeFjH4WY=";

  nativeBuildInputs = [ protobuf ];

  meta = {
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
