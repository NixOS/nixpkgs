{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  curl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-tarpaulin";
  version = "0.37.2";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    tag = finalAttrs.version;
    hash = "sha256-oD8k/M5PChKzG1ek1uH8UP7PoaL9LYot3HCO4Hmetsw=";
  };

  cargoHash = "sha256-lZ4wRI1PEcHDxGe8R1mnp/Gk0IDzqXLvosfzkZOIhug=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
  ];

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Code coverage tool for Rust projects";
    mainProgram = "cargo-tarpaulin";
    homepage = "https://github.com/xd009642/tarpaulin";
    changelog = "https://github.com/xd009642/tarpaulin/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      hugoreeves
      progrm_jarvis
    ];
  };
})
