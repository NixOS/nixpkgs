{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  xcodebuild,
  protobuf,
  boringssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libsignal-ffi";
  # must match the version used in mautrix-signal
  # see https://github.com/mautrix/signal/issues/401
  version = "0.93.2";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "signalapp";
    repo = "libsignal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U32vd5TzgA1LwlFgLUJU30gUeQoYnKI7kYnhy+d8eQk=";
  };

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcodebuild ];

  env = {
    BORING_BSSL_INCLUDE_PATH = boringssl.dev + "/include";
    BORING_BSSL_PATH = boringssl;
    NIX_LDFLAGS = if stdenv.hostPlatform.isDarwin then "-lc++" else "-lstdc++";
  };

  cargoHash = "sha256-5thq1MXL792u87fv6M5E1oi8gq6S8dnTsy3k26T7pgM=";

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
})
