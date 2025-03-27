{
  lib,
  stdenv,
  fetchFromGitHub,
  fftwFloat,
  chafa,
  glib,
  libopus,
  opusfile,
  libvorbis,
  taglib,
  faad2,
  libogg,
  pkg-config,
  versionCheckHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kew";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "ravachol";
    repo = "kew";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DzJ+7PanA15A9nIbFPWZ/tdxq4aDyParJORcuqHV7jc=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    fftwFloat.dev
    chafa
    glib.dev
    libopus
    opusfile
    libvorbis
    taglib
    faad2
    libogg
  ];

  installFlags = [
    "MAN_DIR=${placeholder "out"}/share/man"
    "PREFIX=${placeholder "out"}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Command-line music player for Linux";
    homepage = "https://github.com/ravachol/kew";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      demine
      matteopacini
    ];
    mainProgram = "kew";
  };
})
