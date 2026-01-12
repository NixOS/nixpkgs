{
  stdenvNoCC,
  lib,
  protobuf,
  rustPlatform,
  fetchFromGitHub,
  pkgsBuildHost,
  openssl,
  pkg-config,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gurk-rs";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "boxdot";
    repo = "gurk-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m7oZM2uCGENrADh+qrNODvYWxgbh1ahthkWjFnAVXjw=";
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoHash = "sha256-15z4jKKGfSH1LXX1cXpwRjWI/ITaj3dzlscE7Vrh9Xw=";

  nativeBuildInputs = [
    protobuf
    pkg-config
  ];

  buildInputs = [ openssl ];

  env = {
    NIX_LDFLAGS = lib.optionalString (
      with stdenvNoCC.hostPlatform; (isDarwin && isx86_64)
    ) "-framework AppKit";
    OPENSSL_NO_VENDOR = true;
    PROTOC = "${lib.getExe pkgsBuildHost.protobuf}";
  };

  useNextest = true;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Signal Messenger client for terminal";
    mainProgram = "gurk";
    homepage = "https://github.com/boxdot/gurk-rs";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      devhell
      mattkang
    ];
  };
})
