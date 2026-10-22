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
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "zmwangx";
    repo = "metadata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E9UL10RYHibbaLIHbgMxuOAz7RLKGcZgyfvS1HDFZjE=";
  };

  cargoHash = "sha256-oVP9DXnVU1uZrGkJuELRtExpQnYqrzhjxGpIDWDbbbA=";

  env.FFMPEG_DIR = ffmpeg.dev;

  nativeBuildInputs = [
    pkg-config
    asciidoc
    installShellFiles
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    ffmpeg
    glib
  ];

  postBuild = ''
    a2x --doctype manpage --format manpage man/metadata.1.adoc
  '';

  postInstall = ''
    installManPage man/metadata.1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Media metadata parser and formatter designed for human consumption, powered by FFmpeg";
    license = lib.licenses.mit;
    homepage = "https://github.com/zmwangx/metadata";
    mainProgram = "metadata";
    maintainers = with lib.maintainers; [
      debtquity
    ];
  };
})
