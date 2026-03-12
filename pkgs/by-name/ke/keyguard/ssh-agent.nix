{
  src,
  version,

  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "keyguard-ssh-agent";
  inherit src version;

  sourceRoot = "${src.name}/desktopSshAgent/src";

  cargoHash = "sha256-P9kGoaCCOMOT7Ry2PU6aMzDoy+oKikXlcRBTDc8j3bw=";

  nativeBuildInputs = [ protobuf ];

  doCheck = false;
}
