{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  cacert,
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
  version = "2.2.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = "ncro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-attdCg/FjUooYxVidEDR5wVeQ8aAPAj4b6HQVL17Tng=";
  };

  cargoHash = "sha256-woqDFlQ8r/8KMVLW6K8ucrMPBNZklqmiaaAevQnzbPk=";

  useNextest = true;

  nativeBuildInputs = [
    pkg-config
    cacert
  ]
  ++ (lib.optionals hasWild [
    wild
    clang
  ]);

  buildInputs = [
    openssl.dev
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  env = {
    # reqwest (rustls) needs a CA bundle to construct a TLS client, even in
    # tests that never make network requests.
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    # Link nixpkgs c libs, no vendored copies.
    OPENSSL_NO_VENDOR = 1;
  }
  // lib.optionalAttrs hasWild {
    RUSTFLAGS = "-Clinker=${clang}/bin/clang -Clink-arg=--ld-path=wild";
  };

  meta = {
    homepage = "https://github.com/manic-systems/ncro";
    description = "Lightweight HTTP proxy, optimized for Nix binary cache routing";
    changelog = "https://github.com/manic-systems/ncro/releases/tag/v${finalAttrs.version}";
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
