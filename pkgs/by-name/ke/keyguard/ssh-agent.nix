{
  protobuf,
  rustPlatform,

  src,
  version,
}:

rustPlatform.buildRustPackage {
  pname = "keyguard-ssh-agent";
  inherit version;

  src = src + "/desktopSshAgent/src";

  cargoHash = "sha256-oQqr4RUtbSagBIeG/Emu1QxZ/zbm1oA4SlO5He3uJqI=";

  nativeBuildInputs = [ protobuf ];

  doCheck = false;
}
