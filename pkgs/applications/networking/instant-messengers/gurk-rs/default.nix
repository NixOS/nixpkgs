{
  stdenv,
  lib,
  protobuf,
  rustPlatform,
  fetchFromGitHub,
  Cocoa,
  pkgsBuildHost,
  openssl,
  pkg-config,
  versionCheckHook,
  nix-update-script,
  gurk-rs,
}:

rustPlatform.buildRustPackage rec {
  pname = "gurk-rs";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = "gurk-rs";
    tag = "v${version}";
    hash = "sha256-FPbEtk2A7qs/85VsmfV1uPsVZ7V5WKhMKeWrzUt5L4w=";
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  useFetchCargoVendor = true;

  cargoHash = "sha256-yLZKat6NNZkbyTpAVpOvDAbbNajh4Vaebc7fmK0I3Mc=";

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
