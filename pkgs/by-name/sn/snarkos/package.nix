{
  Security ? null,
  autoPatchelfHook,
  curl,
  fetchFromGitHub,
  lib,
  llvmPackages,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "snarkos";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "ProvableHQ";
    repo = "snarkOS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7wa7uD4tcZa9nQ2GSgleSNQ/ugJ4sRshqcZhQpz49lY=";
  };

  patches = [
    ./0001-remove-update-subcommand.patch
    ./0002-fix-auditable.patch
  ];

  cargoHash = "sha256-cW+QZvXvgQ5J1lBJ/+IdL2Pq7XzHRb3Wl+OaLGCznzI=";

  nativeBuildInputs = [
    llvmPackages.lld
  ]
  ++ (lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    pkg-config
    rustPlatform.bindgenHook
  ]);

  buildInputs = [
    openssl
    stdenv.cc.cc.lib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Security
    curl
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  nativeCheckInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  preCheck = ''
    export LD_LIBRARY_PATH="${lib.makeLibraryPath [ openssl ]}"
  '';

  meta = {
    description = "Decentralized Operating System for Zero-Knowledge Applications";
    homepage = "https://github.com/provableHQ/snarkOS";
    changelog = "https://github.com/ProvableHQ/snarkOS/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.unix;
    mainProgram = "snarkos";
  };
})
