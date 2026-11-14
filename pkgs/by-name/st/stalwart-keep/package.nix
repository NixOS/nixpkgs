{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,

  aws-lc,
  pkg-config,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stalwart-keep";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "keep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qJlAgPtt3sPzf4S70qPZ+CSlLL/WrY298vdsRjlkc2M=";
  };
  cargoHash = "sha256-rcKEaNugFptEoEq8ZrCbAGiG2ihxOOF6lmKLeMBO55g=";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    aws-lc
    zstd
  ];

  cargoBuildFlags = [
    "-p"
    "keep-server"
    "--bin"
    "keep"
  ];

  doCheck = true;
  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Ephemeral key-value store and event stream server for clustered applications";
    longDescription = ''
      Stalwart Keep is an ephemeral state and cluster messaging server for clustered applications
      with a thread-per-core, share-nothing design.
    '';
    homepage = "https://github.com/stalwartlabs/keep";
    changelog = "https://github.com/stalwartlabs/keep/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.OR [
      lib.licenses.agpl3Only
      lib.licenses.stalwart
    ];
    mainProgram = "keep";
    maintainers = with lib.maintainers; [
      debtquity
    ];
    platforms = lib.platforms.linux;
  };
})
