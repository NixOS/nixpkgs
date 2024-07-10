{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, runCommand
, xcodebuild
, protobuf
, boringssl
, darwin
}:
let
  # boring-sys expects the static libraries in build/ instead of lib/
  boringssl-wrapper = runCommand "boringssl-wrapper" { } ''
    mkdir $out
    cd $out
    ln -s ${boringssl.out}/lib build
    ln -s ${boringssl.dev}/include include
  '';
in
rustPlatform.buildRustPackage rec {
  pname = "libsignal-ffi";
  # must match the version used in mautrix-signal
  # see https://github.com/mautrix/signal/issues/401
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "libsignal";
    rev = "v${version}";
    hash = "sha256-Kb7tQyql0mJizysP2uXaA14RCaDr1b1/Ax764u+dCFQ=";
  };

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
  ] ++ lib.optionals stdenv.isDarwin [ xcodebuild ];

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Security
  ]);

  env.BORING_BSSL_PATH = "${boringssl-wrapper}";

  # The Cargo.lock contains git dependencies
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "boring-4.6.0" = "sha256-IjkpCKZ4Y1UTrFPg4g/bak+/mJFiyfUyxtTtT5uzcUY=";
      "curve25519-dalek-4.1.1" = "sha256-p9Vx0lAaYILypsI4/RVsHZLOqZKaa4Wvf7DanLA38pc=";
    };
  };

  cargoBuildFlags = [ "-p" "libsignal-ffi" ];

  meta = with lib; {
    description = "C ABI library which exposes Signal protocol logic";
    homepage = "https://github.com/signalapp/libsignal";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ niklaskorz ];
  };
}
