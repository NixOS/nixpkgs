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
}:

rustPlatform.buildRustPackage rec {
  pname = "gurk-rs";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-g0V6FPkCpIEWx+/kDG9+0NtlCVj6jc1gbkkzOSl/lAo=";
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-s/Z9NEdXtLyzvb22Je9hKLkmOxsvI/qoEHlcNbeBY+0=";

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

  meta = with lib; {
    description = "Signal Messenger client for terminal";
    mainProgram = "gurk";
    homepage = "https://github.com/boxdot/gurk-rs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ devhell ];
  };
}
