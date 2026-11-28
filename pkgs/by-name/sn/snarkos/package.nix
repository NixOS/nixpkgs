{
  Security ? null,
  autoPatchelfHook,
  curl,
  aws-lc,
  fetchFromGitHub,
  lib,
  libgit2,
  llvmPackages,
  nix-update-script,
  openssl,
  pkg-config,
  rust-jemalloc-sys,
  rustPlatform,
  stdenv,
  versionCheckHook,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "snarkos";
  version = "4.13.1";

  src = fetchFromGitHub {
    owner = "aleo-labs-protocol";
    repo = "snarkOS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tU3H/WQscyBSICR4V/SHKkUZtz5FNcgBFZk8YEX6KZQ=";
  };

  patches = [
    ./0001-remove-update-subcommand.patch
    ./0002-fix-auditable.patch
  ];

  cargoHash = "sha256-1OBYdbxCTlOG6dd5tNfrcaYhqFOUA54Vt+Cp8NWy/QY=";

  nativeBuildInputs = [
    llvmPackages.lld
  ]
  ++ (lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    pkg-config
    rustPlatform.bindgenHook
  ]);

  buildInputs = [
    aws-lc
    libgit2
    openssl
    stdenv.cc.cc.lib
    zstd
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
    rust-jemalloc-sys
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Security
    curl
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  nativeCheckInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  preCheck = ''
    export LD_LIBRARY_PATH="${lib.makeLibraryPath [ openssl ]}"
  '';

  meta = {
    description = "Decentralized Operating System for Zero-Knowledge Applications";
    homepage = "https://github.com/ProvableHQ/snarkOS";
    changelog = "https://github.com/ProvableHQ/snarkOS/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "snarkos";
  };
})
