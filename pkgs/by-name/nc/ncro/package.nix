{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  cacert,
  sqlite,
  wild ? null,
  clang,
  nix-update-script,
  versionCheckHook,
}:
let
  hasWild =
    stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch64);
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ncro";
  version = "2.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = "ncro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xuMwlDKryFsd+wYA1sQSJZWoU4f+c3/tqs2rb8sSfXg=";
  };

  cargoHash = "sha256-twPCq6VEAWezccoP4c/UqIgIgseXwQa60zxHsZE4fbU=";

  useNextest = true;

  nativeBuildInputs = [
    pkg-config
    cacert
  ]
  ++ lib.optionals hasWild [
    wild
    clang
  ];

  buildInputs = [
    openssl
    sqlite
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  env = {
    # reqwest (rustls) needs a CA bundle to construct a TLS client, even in
    # tests that never make network requests.
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  }
  // lib.optionalAttrs hasWild {
    RUSTFLAGS = "-Clinker=${clang}/bin/clang -Clink-arg=--ld-path=wild";
  };

  meta = {
    homepage = "https://github.com/manic-systems/ncro";
    description = "Lightweight HTTP proxy, optimized for Nix binary cache routing";
    changelog = "https://github.com/manic-systems/ncro/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      amaanq
      atagen
      faukah
      max
      NotAShelf
    ];
    mainProgram = "ncro";
  };
})
