{
  stdenv,
  lib,
  protobuf,
  rustPlatform,
  fetchFromGitHub,
  darwin,
  pkgsBuildHost,
  openssl,
  pkg-config,
  versionCheckHook,
  nix-update-script,
  gurk-rs,
}:

let
  inherit (darwin.apple_sdk.frameworks) Cocoa;
in
rustPlatform.buildRustPackage rec {
  pname = "gurk-rs";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = "gurk-rs";
    tag = "v${version}";
    hash = "sha256-cNKUQlCzhOgyWoitHjRoVdehj8AUEslHBCGxH9nRWF4=";
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  useFetchCargoVendor = true;

  cargoHash = "sha256-eh7ZD8ZX1oKiJbJcVtk6pczb6HxNM6md93P/22Qn5u0=";

  nativeBuildInputs = [
    protobuf
    pkg-config
  ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Cocoa ];

  NIX_LDFLAGS = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    "-framework"
    "AppKit"
  ];

  PROTOC = "${pkgsBuildHost.protobuf}/bin/protoc";

  OPENSSL_NO_VENDOR = true;

  useNextest = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = [ "--version" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Signal Messenger client for terminal";
    mainProgram = "gurk";
    homepage = "https://github.com/boxdot/gurk-rs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ devhell ];
  };
}
