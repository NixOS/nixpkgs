{
  lib,
  protobuf,
  rustPlatform,
  fetchFromGitHub,
  pkgsBuildHost,
  aws-lc,
  openssl,
  pkg-config,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
  sqlite,
  sqlcipher,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gurk-rs";
  version = "0.11.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = "gurk-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RuDzSlFoNllCfi2GzGq/OmWhGGLL2w5yhCMe8BhZfII=";
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoHash = "sha256-DD8VS79jZ+YPQY1iVqDIbBh3/gtsuhA5Wj6H4CwegKQ=";

  nativeBuildInputs = [
    protobuf
    pkg-config
  ];

  buildInputs = [
    aws-lc
    openssl
    sqlite
    sqlcipher
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    PROTOC = "${lib.getExe pkgsBuildHost.protobuf}";
  };

  useNextest = true;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Signal Messenger client for terminal";
    mainProgram = "gurk";
    homepage = "https://github.com/boxdot/gurk-rs";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      devhell
      mattkang
      nicknb
      faukah
    ];
  };
})
