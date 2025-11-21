{
  stdenv,
  lib,
  protobuf,
  rustPlatform,
  fetchFromGitHub,
  pkgsBuildHost,
  openssl,
  pkg-config,
  sqlx-cli,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "gurk-rs";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = "gurk-rs";
    rev = "85c4be0ad11651b7816fb5294eab05c1946f7c95";
    hash = "sha256-ne+cuGZ7FBBZZ/XBXhD44V3ZLDo3DfXDUkiB1Ftt848=";
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoHash = "sha256-0J6ebycXG0TEZ0ur9Q1Y2nRlfLeEoZGCVE5xfFS5yLA=";

  nativeBuildInputs = [
    protobuf
    pkg-config
  ];

  buildInputs = [ openssl ];

  NIX_LDFLAGS = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    "-framework"
    "AppKit"
  ];

  PROTOC = "${pkgsBuildHost.protobuf}/bin/protoc";

  OPENSSL_NO_VENDOR = true;

  useNextest = true;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Signal Messenger client for terminal";
    mainProgram = "gurk";
    homepage = "https://github.com/boxdot/gurk-rs";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ devhell ];
  };
}
