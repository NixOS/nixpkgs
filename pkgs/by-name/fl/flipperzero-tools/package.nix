{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  udev,
  llvmPackages,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flipperzero-tools";
  __structuredAttrs = true;
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "flipperzero-rs";
    repo = "flipperzero-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jp0iYZFHg6+3gZrIKqpk2BqAWWV4nhy5om1kQVapTsA=";
  };

  sourceRoot = "${finalAttrs.src.name}/tools";

  # upstream's TOOLCHAIN const has no unix+aarch64 branch (only macos+aarch64);
  # the aarch64-linux toolchain dir name matches upstream's fbtenv.sh naming
  # ($(uname -m)-$(uname -s)) and a real archive exists at that path.
  postPatch = ''
        substituteInPlace src/bin/generate-bindings.rs \
          --replace-fail \
            'const TOOLCHAIN: &str = "../../../toolchain/x86_64-linux/arm-none-eabi/include";' \
            'const TOOLCHAIN: &str = "../../../toolchain/x86_64-linux/arm-none-eabi/include";
    #[cfg(all(target_os = "linux", target_arch = "aarch64"))]
    const TOOLCHAIN: &str = "../../../toolchain/aarch64-linux/arm-none-eabi/include";'
  '';

  cargoHash = "sha256-kn4CgvEZMSXWS5kOpyZAclo10CHIyVDh21lQBlJa0yk=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ udev ];

  # upstream binary names are generic; prefix the ones that would clash on PATH.
  # fap-lld and run-fap keep their names since project cargo configs call them.
  postInstall = ''
    mv $out/bin/storage $out/bin/flipperzero-storage
    mv $out/bin/serial_cli $out/bin/flipperzero-serial-cli
    mv $out/bin/generate-bindings $out/bin/flipperzero-generate-bindings
    # bindgen loads libclang at runtime
    wrapProgram $out/bin/flipperzero-generate-bindings \
      --set-default LIBCLANG_PATH ${lib.getLib llvmPackages.libclang}/lib
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Host tools for Rust on the Flipper Zero: FAP linker, serial storage and app runner";
    homepage = "https://github.com/flipperzero-rs/flipperzero-rs";
    changelog = "https://github.com/flipperzero-rs/flipperzero-rs/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hz2 ];
    platforms = lib.platforms.unix;
    mainProgram = "fap-lld";
  };
})
