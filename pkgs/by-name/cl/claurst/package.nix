{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  gitMinimal,
  cacert,
  versionCheckHook,
  nix-update-script,
  alsa-lib,
  dbus,
  libxcb,
  libxkbcommon,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "claurst";
  version = "0.1.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kuberwastaken";
    repo = "claurst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-36U4Wh99sEK/iJfYo914OkREEhwys6zZQz1tIwIPfpc=";
  };

  sourceRoot = "${finalAttrs.src.name}/src-rust";

  cargoHash = "sha256-Xr9AuV5hp9DuyMBeSAv+3hOuC0P2lkli837FA+FJHw0=";

  # acp_smoke.rs spawns the built binary, which eagerly constructs a Bedrock
  # reqwest client on startup (crates/api/src/providers/bedrock.rs); rustls
  # needs a real CA bundle for that or it panics before it can speak ACP.
  nativeCheckInputs = [ cacert ];
  preCheck = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  # aws-lc-sys (rustls' default crypto provider) and btls-sys (BoringSSL fork
  # behind wreq, used for Anthropic TLS fingerprint impersonation) each vendor
  # and build a BoringSSL-family C/C++ tree via cmake, with btls-sys also
  # generating its FFI bindings with bindgen.
  nativeBuildInputs = [
    pkg-config
    cmake
    gitMinimal # btls-sys runs `git init`/`git apply` to patch its vendored BoringSSL tree
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib # cpal, behind the default `voice` feature
    dbus # xcap's Wayland portal / D-Bus screenshot backend
    libxcb # xcap's X11 screenshot backend
    libxkbcommon # enigo's keysym translation
  ];

  checkFlags = [
    # asserts no tracked file path contains the substring "build/"; false-positives
    # in the Nix build sandbox because its build root is literally /build, so every
    # tempfile::tempdir() path starts with /build/... regardless of gitignore matching
    "--skip=gitignore_respected"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source multi-provider terminal coding agent";
    homepage = "https://github.com/kuberwastaken/claurst";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.rayhem ];
    mainProgram = "claurst";
    platforms = lib.platforms.linux;
  };
})
