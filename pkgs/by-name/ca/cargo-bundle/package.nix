{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  stdenv,
  libxkbcommon,
  wayland,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-bundle";
  version = "0.12.0";

  __structuredAttrs = true;

  # git source doesn't ship a cargo.lock
  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-9H4FtNjyXGr7Dkw7hepy2Du9u83CjLTPMflGXUI8GG0=";
  };

  cargoHash = "sha256-w35I7+GxlquxbqR5xl+5kn1sSzi2U38dgCy/X6CTFUY=";

  # let the integration tests pick up the prebuilt release binary instead of
  # assuming a cargo debug-build layout (target/debug/cargo-bundle)
  patches = [ ./tests-env.patch ];

  # native-tls links openssl on Linux, found via pkg-config; on darwin it
  # uses the Security/system-libs framework instead
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl

    # linked by the winit dev-dependency when tests build
    libxkbcommon
    wayland
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wrap rust executables in OS-specific app bundles";
    longDescription = ''
      cargo-bundle is a tool used to generate installers or app bundles for
      executables built with cargo. It can create .app and .dmg bundles for
      macOS, .deb packages and AppImage bundles for Linux, and .msi
      installers for Windows (iOS and Windows support is experimental).
    '';
    homepage = "https://github.com/burtonageo/cargo-bundle";
    changelog = "https://github.com/burtonageo/cargo-bundle/tags";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "cargo-bundle";
    platforms = lib.platforms.unix;
  };
})
