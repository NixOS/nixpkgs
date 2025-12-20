{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  runCommand,
  xcodebuild,
  protobuf,
  boringssl,
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
  version = "0.86.8";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "signalapp";
    repo = "libsignal";
    tag = "v${version}";
    hash = "sha256-+GFuwS4y8yr86ETVIjlz/6HocAamASmBOIjkTLtCIag=";
  };

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcodebuild ];

  env.BORING_BSSL_PATH = "${boringssl-wrapper}";
  env.NIX_LDFLAGS = if stdenv.hostPlatform.isDarwin then "-lc++" else "-lstdc++";

  cargoHash = "sha256-uiMct9ygg1c1rQb6RsM2AoibuKCExPy9P75C7jDX8Cs=";

  cargoBuildFlags = [
    "-p"
    "libsignal-ffi"
  ];

  meta = {
    description = "C ABI library which exposes Signal protocol logic";
    homepage = "https://github.com/signalapp/libsignal";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      pentane
      SchweGELBin
    ];
  };
}
