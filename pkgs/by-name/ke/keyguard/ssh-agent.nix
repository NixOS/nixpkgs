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

  cargoHash = "sha256-/IQUqz/hi2I5LoTw0pj/vSu40Yb6BqisSn1W+/HCt4I=";

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail "../../commonSshAgent" "${src + "/commonSshAgent"}"
  '';

  nativeBuildInputs = [ protobuf ];

  doCheck = false;
}
