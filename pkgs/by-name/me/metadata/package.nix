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

  cargoHash = "sha256-tUVaseaavm746sxaA2A3ua4ZxzoKSnRQ4rJRBeO9t1U=";

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
