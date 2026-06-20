{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pkg-config,
  protobuf,
  perl,
  jdk,
  gitMinimal,
  llvmPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libsignal-jni";
  version = "0.92.1";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "libsignal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gAXLt0e2k5PA6PgFRQa22oGuNLM7TGkOKQnYtFhn8I8=";
  };

  cargoHash = "sha256-TqYxkkzlbgrc7jkAubz3TsXhcU8Do5IFaLRqSPiZVR0=";

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    perl # needed by boring-sys/BoringSSL
    jdk # for JNI headers
    gitMinimal # needed by boring-sys build script
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # bindgen needs to find C headers (stdlib.h etc.)
  # On Linux, libc headers are in a separate .dev output; on Darwin they
  # come from the SDK and libclang already knows where to find them.
  BINDGEN_EXTRA_CLANG_ARGS =
    if stdenv.hostPlatform.isDarwin then
      "-isystem ${llvmPackages.libclang.lib}/lib/clang/${lib.versions.major llvmPackages.libclang.version}/include"
    else
      "-isystem ${stdenv.cc.libc.dev}/include -isystem ${llvmPackages.libclang.lib}/lib/clang/${lib.versions.major llvmPackages.libclang.version}/include";

  buildAndTestSubdir = "rust/bridge/jni";

  cargoBuildFlags = [
    "-p"
    "libsignal-jni"
  ];

  RUSTFLAGS = "--cfg aes_armv8 --cfg tokio_unstable";

  env = {
    BORING_BSSL_SOURCE_EXTERNAL = "0";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    find target -name "libsignal_jni${stdenv.hostPlatform.extensions.sharedLibrary}" | head -1 | while read f; do
      install -Dm755 "$f" "$out/lib/$(basename "$f")"
    done
    runHook postInstall
  '';

  meta = {
    description = "Signal Protocol JNI native library";
    homepage = "https://github.com/signalapp/libsignal";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
  };
})
