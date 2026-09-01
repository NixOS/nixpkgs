{
  lib,
  fetchFromGitHub,
  pkg-config,
  ffmpeg,
  rustPlatform,
  glib,
  installShellFiles,
  asciidoc,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "metadata";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "zmwangx";
    repo = "metadata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gDOYqPwrWUfUTCx+p+ZpwsP8XxUufDCGem/WzW5cQPc=";
  };

  cargoPatches = [
    # bump ffmpeg-next 8.0.0 -> 8.1.0 for ffmpeg 8.1 enum variants
    ./ffmpeg-next-8.1.patch
  ];

  cargoHash = "sha256-TgF88oaf6567Xk20TkqbtE+H+nEKTiUSyswvxvCNFVI=";

  nativeBuildInputs = [
    pkg-config
    asciidoc
    installShellFiles
    rustPlatform.bindgenHook
  ];

  postBuild = ''
    a2x --doctype manpage --format manpage man/metadata.1.adoc
  '';
  postInstall = ''
    installManPage man/metadata.1
  '';

  buildInputs = [
    ffmpeg
    glib
  ];

  env.FFMPEG_DIR = ffmpeg.dev;

  checkFlags = [
    # "AAC (HE-AAC v2)" is reported as "AAC (LC)" in newer ffmpeg
    # https://github.com/zmwangx/metadata/issues/13
    "--skip=aac_he_aac"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Media metadata parser and formatter designed for human consumption, powered by FFmpeg";
    maintainers = [ ];
    license = lib.licenses.mit;
    homepage = "https://github.com/zmwangx/metadata";
    mainProgram = "metadata";
  };
})
