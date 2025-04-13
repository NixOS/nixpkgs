{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  liboqs,
  openssl,
  llvmPackages,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "liboqs-rust";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "open-quantum-safe";
    repo = "liboqs-rust";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1jWjgyl5hpFwxxV7bmIqV6CRA0VvaIeUPJkW2ixmuFU=";
  };

  outputs = [
    "out"
    "dev"
  ];

  cargoLock.lockFile = ./Cargo.lock;
  cargoBuildFlags = [ "--lib" ];

  propagatedBuildInputs = [ liboqs ];

  installPhase = ''
    runHook preInstall

       mkdir -p $out/lib $dev
       TARGET_DIR="target/${stdenv.hostPlatform.config}/release"

       find "$TARGET_DIR" -maxdepth 1 \
         \( -name 'liboqs.rlib' -o -name 'liboqs_sys.rlib' \) \
         -exec cp -v {} $out/lib \;

       find "$TARGET_DIR/deps" -maxdepth 1 \
         \( -name 'liboqs-*.rlib' -o -name 'liboqs_sys-*.rlib' \) \
         -exec cp -v {} $out/lib \;

       cp -v Cargo.toml "$dev/"
       cp -vr oqs "$dev/"
       cp -vr oqs-sys "$dev/"

       echo "Installed libraries:"
       ls -l $out/lib
       echo "Installed development files:"
       ls -l $dev

       runHook postInstall
  '';

  postUnpack = ''
    cp ${./Cargo.lock} "$sourceRoot/Cargo.lock"
  '';

  nativeBuildInputs = [
    pkg-config
    llvmPackages.clang
  ];

  buildInputs = [
    liboqs
    openssl
  ];

  env = {
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
    BINDGEN_EXTRA_CLANG_ARGS = "-I${liboqs.dev}/include";
    LIBOQS_NO_VENDOR = "1";
    PKG_CONFIG_PATH = "${liboqs.dev}/lib/pkgconfig";
  };

  doCheck = true;

  meta = {
    description = "Rust bindings for liboqs, a library for quantum-resistant cryptography";
    homepage = "https://github.com/open-quantum-safe/liboqs-rust";
    changelog = "https://github.com/open-quantum-safe/liboqs-rust/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tanya1866 ];
  };
})
