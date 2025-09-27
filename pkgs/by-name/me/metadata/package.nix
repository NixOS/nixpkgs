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
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "zmwangx";
    repo = "metadata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wZ1wLygPFBFZsSYJGxNzYV+mXtbN68GY3nMYDFHPZHo=";
  };

  cargoHash = "sha256-pWekXsjAhK4wyjf95nZO+Wj9PcH87D8vYsRFAE/w/sw=";

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
