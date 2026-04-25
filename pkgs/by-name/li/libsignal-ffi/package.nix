{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  xcodebuild,
  protobuf,
  boringssl,

  withShared ? !stdenv.hostPlatform.isStatic,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libsignal-ffi";
  # must match the version used in mautrix-signal
  # see https://github.com/mautrix/signal/issues/401
  version = "0.92.1";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "signalapp";
    repo = "libsignal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gAXLt0e2k5PA6PgFRQa22oGuNLM7TGkOKQnYtFhn8I8=";
  };

  postPatch =
    lib.optionalString withShared ''
      substituteInPlace rust/bridge/ffi/Cargo.toml \
        --replace-fail 'crate-type = ["staticlib"]' 'crate-type = ["cdylib"]'
    ''
    + lib.optionalString boringssl.passthru.isShared ''
      substituteInPlace $cargoDepsCopy/*/boring-sys-*/build/main.rs \
        --replace-fail "cargo:rustc-link-lib=static=crypto" "cargo:rustc-link-lib=dylib=crypto" \
        --replace-fail "cargo:rustc-link-lib=static=ssl" "cargo:rustc-link-lib=dylib=ssl"
    '';

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

  cargoHash = "sha256-TqYxkkzlbgrc7jkAubz3TsXhcU8Do5IFaLRqSPiZVR0=";

  cargoBuildFlags = [
    "-p"
    "libsignal-ffi"
  ];

  postFixup = lib.optionalString (withShared && stdenv.hostPlatform.isDarwin) ''
    dylib="$out/lib/libsignal_ffi.dylib"
    install_name_tool -id "$dylib" "$dylib"
  '';

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
