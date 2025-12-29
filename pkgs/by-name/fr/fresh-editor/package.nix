{
  lib,
  callPackage,
  rustPlatform,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  openssl,
  gzip,
  gitMinimal,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  librusty_v8 ? callPackage ./librusty_v8.nix {
    inherit (callPackage ./fetchers.nix { }) fetchLibrustyV8;
  },
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fresh";
  version = "0.1.65";

  src = fetchFromGitHub {
    owner = "sinelaw";
    repo = "fresh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eSpu95r5v28wP1l6GuNFT9h+NpiS2AAbZ+d6mK9JTCM=";
  };

  cargoHash = "sha256-P2o8rJVrw+g8M3iiK1fY9/+Sxse1SSChwJ+NJwRI0Io=";

  nativeBuildInputs = [
    pkg-config
    gzip
    writableTmpDirAsHomeHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  nativeCheckInputs = [ gitMinimal ];

  # Permission denied errors
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=services::release_checker::tests::"
  ];

  cargoTestFlags = [
    "--lib"
    "--bins"
  ];

  env = {
    RUSTY_V8_ARCHIVE = librusty_v8;
    OPENSSL_NO_VENDOR = true;
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based text editor with LSP support and TypeScript plugins";
    homepage = "https://github.com/sinelaw/fresh";
    changelog = "https://github.com/sinelaw/fresh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    mainProgram = "fresh";
    maintainers = with lib.maintainers; [ chillcicada ];
  };
})
