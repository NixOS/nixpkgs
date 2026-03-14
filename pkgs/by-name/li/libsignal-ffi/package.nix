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
  version = "0.87.5";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "signalapp";
    repo = "libsignal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xffBXvq1ikesIjw6cXfphnTIiyuMiUcY8h0pzSgfD8U=";
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

  cargoHash = "sha256-MwAtUrLoSi/pjsBWOAd9JoepAueq17hkZCH21q72O3w=";

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
