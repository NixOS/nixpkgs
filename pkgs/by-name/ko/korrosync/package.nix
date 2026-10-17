{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  openssl,
  apple-sdk,

  # nativeCheckInputs
  addBinToPathHook,
  versionCheckHook,
  cacert,

  withTls ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "korrosync";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "szaffarano";
    repo = "korrosync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ubGOQ6JM9wo5428Yf1F1K+nllG9EDQBrBx4yr6PMPG0=";
  };

  cargoHash = "sha256-3oMPREUWwKNEeaf8FdWHdjPMLU5xMSMzxKrmrhU+iko=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk
  ];

  buildFeatures = lib.optional withTls "tls";

  nativeCheckInputs = [
    addBinToPathHook
    cacert
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    changelog = "https://github.com/szaffarano/korrosync/releases/tag/${finalAttrs.src.tag}";
    description = "KOReader Sync Server";
    homepage = "https://github.com/szaffarano/korrosync";
    license = lib.licenses.mit;
    mainProgram = "korrosync";
    maintainers = with lib.maintainers; [ shymega ];
    platforms = lib.platforms.unix ++ lib.platforms.darwin;
  };
})
