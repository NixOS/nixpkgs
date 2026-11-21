{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  zlib,
  versionCheckHook,
}:

let
  version = "1.99.0.0";
  base = "https://github.com/esp-rs/rust-build/releases/download/v${version}";

  platforms = {
    x86_64-linux = {
      triple = "x86_64-unknown-linux-gnu";
      hash = "sha256-sRN2zyi0OtMb0mTeaYf29QuACIJNyxLmpyEjMdpajtc=";
    };
    aarch64-linux = {
      triple = "aarch64-unknown-linux-gnu";
      hash = "sha256-726YZHVgQ5cZ+wpUYEh9zwe2JNpK7XFcSOf8LRjbRqE=";
    };
    aarch64-darwin = {
      triple = "aarch64-apple-darwin";
      hash = "sha256-l3VNo1Xxa2y2M1ORtzYZLvrx2mijn3pRxM4Zf0JqJdc=";
    };
  };

  platform =
    platforms.${stdenv.hostPlatform.system}
      or (throw "esp-rust-bin: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "esp-rust-bin";
  __structuredAttrs = true;
  strictDeps = true;
  inherit version;

  srcs = [
    (fetchurl {
      url = "${base}/rust-${version}-${platform.triple}.tar.xz";
      inherit (platform) hash;
    })
    # xtensa has no prebuilt std; firmware builds core and alloc with -Zbuild-std
    (fetchurl {
      url = "${base}/rust-src-${version}.tar.xz";
      hash = "sha256-Mc7jrGYsAmQ3yJWEbLCTtdhDjBOqbF+NVh4iv3+L5UM=";
    })
  ];
  sourceRoot = ".";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    zlib
    stdenv.cc.cc.lib
  ];
  # rust-gdbgui and friends are optional wrappers around a debugger we do not ship
  autoPatchelfIgnoreMissingDeps = [ "libpython*" ];

  installPhase = ''
    runHook preInstall
    for d in rust-nightly-${platform.triple} rust-src-nightly; do
      patchShebangs $d/install.sh
      $d/install.sh --prefix=$out --disable-ldconfig \
        --without=rust-docs,rust-docs-json-preview
    done
    runHook postInstall
  '';

  dontStrip = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/rustc";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/rustc --print target-list | grep -qx xtensa-esp32-none-elf
  '';

  meta = {
    description = "Rust toolchain with Xtensa support for ESP32, ESP32-S2 and ESP32-S3";
    longDescription = ''
      Prebuilt Rust fork from esp-rs/rust-build, the same toolchain espup installs.
      Xtensa is not supported by upstream rustc, so bare-metal (esp-hal) and
      ESP-IDF projects on Xtensa chips need this compiler. RISC-V ESP32 chips
      work with the regular rustc.
    '';
    homepage = "https://github.com/esp-rs/rust-build";
    changelog = "https://github.com/esp-rs/rust-build/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.attrNames platforms;
    maintainers = with lib.maintainers; [ hz2 ];
    mainProgram = "rustc";
  };
}
